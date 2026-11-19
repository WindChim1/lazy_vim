local M = {}

local function fcitx_backend()
  local command
  for _, candidate in ipairs({ "fcitx5-remote", "fcitx-remote" }) do
    if vim.fn.executable(candidate) == 1 then
      command = candidate
      break
    end
  end
  if not command then
    return
  end
  return {
    attach = function() end,
    active = function()
      return true
    end,
    get = function()
      local result = tonumber(vim.fn.system({ command }))
      if vim.v.shell_error == 0 and (result == 1 or result == 2) then
        return result
      end
    end,
    set = function(state)
      vim.fn.system({ command, state == 2 and "-o" or "-c" })
      return vim.v.shell_error == 0
    end,
    english = function()
      return 1
    end,
    toggle = function(state)
      return state == 2 and 1 or 2
    end,
    equal = function(a, b)
      return a == b
    end,
  }
end

function M.setup()
  if M.started or #vim.api.nvim_list_uis() == 0 then
    return
  end
  local windows = vim.fn.has("win32") == 1
  local backend = windows and require("config.ime_windows") or fcitx_backend()
  if not backend then
    return
  end
  M.started = true
  local remembered
  local retry_after = 0
  local restore_failed = false
  local warned = false
  local function apply(state, force)
    if backend.set(state, force) then
      return true
    end
    if not warned then
      warned = true
      vim.schedule(function()
        vim.notify("输入法状态设置失败：当前终端或输入法可能不支持 IME 控制接口。", vim.log.levels.WARN)
      end)
    end
    retry_after = vim.uv.now() + 2000
    return false
  end
  local focused = not windows
  local function inserting(mode)
    return mode:match("^[iR]") ~= nil
  end
  local function normal(mode)
    return mode:match("^n") ~= nil
  end
  local function read()
    if focused and backend.active() and vim.uv.now() >= retry_after then
      local state = backend.get()
      if state == nil then
        retry_after = vim.uv.now() + 2000
      end
      return state
    end
  end
  local function english()
    local current = read()
    if current then
      local target = backend.english(current)
      if not backend.equal(current, target) then
        apply(target)
      end
    end
  end
  local function restore()
    if focused and backend.active() and remembered then
      restore_failed = not apply(remembered)
    end
  end
  local function sync()
    local mode = vim.api.nvim_get_mode().mode
    if inserting(mode) and not restore_failed then
      remembered = read() or remembered
    elseif normal(mode) then
      english()
    end
  end

  backend.attach()
  remembered = read()
  if normal(vim.api.nvim_get_mode().mode) then
    english()
  end

  local group = vim.api.nvim_create_augroup("InputMethodState", { clear = true })
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = group,
    callback = function()
      local old, new = vim.v.event.old_mode, vim.v.event.new_mode
      if inserting(old) and not inserting(new) then
        if not restore_failed then
          remembered = read() or remembered
        end
        restore_failed = false
        english()
      elseif not inserting(old) and inserting(new) then
        restore()
      elseif normal(new) then
        english()
      end
    end,
  })
  vim.api.nvim_create_autocmd("FocusLost", {
    group = group,
    callback = function()
      -- Windows 的输入法状态往往是全局共享的：Normal 模式强制的英文会
      -- 跟着全局状态带到别的应用。离开时恢复记住的状态，让浏览器等
      -- 窗口保持原来的中文。force 是因为此时前台窗口已经不是 Neovim。
      if remembered and normal(vim.api.nvim_get_mode().mode) then
        apply(remembered, true)
      end
      focused = false
    end,
  })
  local function focus()
    focused = true
    backend.attach()
    retry_after = 0
    if inserting(vim.api.nvim_get_mode().mode) then
      remembered = read() or remembered
    elseif normal(vim.api.nvim_get_mode().mode) then
      remembered = remembered or read()
      english()
    end
  end
  vim.api.nvim_create_autocmd("FocusGained", {
    group = group,
    callback = focus,
  })
  -- 有些终端启动时不发送 FocusGained；等实际按键到达后再绑定前台窗口。
  local namespace = vim.api.nvim_create_namespace("InputMethodFocus")
  if windows then
    vim.on_key(function(_, typed)
      if not focused and typed ~= "" then
        focus()
      end
    end, namespace)
  end

  vim.keymap.set({ "i", "n" }, "<C-Space>", function()
    local mode = vim.api.nvim_get_mode().mode
    local current = read()
    if not current then
      return
    end
    if inserting(mode) then
      if apply(backend.toggle(current)) then
        restore_failed = false
        remembered = read() or remembered
      end
    else
      -- Normal 始终保持英文，只切换下次进入 Insert 的状态。
      remembered = backend.toggle(remembered or current)
      english()
    end
  end, { desc = "Toggle remembered input method" })

  -- Windows 可能先处理 Ctrl+Space；轮询真实状态，不依赖按键是否传给 Neovim。
  if windows then
    local timer = assert(vim.uv.new_timer())
    local stopped = false
    timer:start(150, 150, vim.schedule_wrap(function()
      if not stopped then
        sync()
      end
    end))
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = group,
      once = true,
      callback = function()
        stopped = true
        timer:stop()
        timer:close()
        if remembered and normal(vim.api.nvim_get_mode().mode) then
          apply(remembered, true)
        end
      end,
    })
  end
end

return M
