-- Run: nvim --headless -u NONE -i NONE -l tests/ime.lua
local real_vim = vim
local mode = "n"
local state = 2
local callbacks = {}
local mappings = {}
local poll, key
local fail = false
local writes = 0
local backend = {
  attach = function() end,
  active = function() return true end,
  get = function() return state end,
  set = function(value)
    writes = writes + 1
    if fail then return false end
    state = value
    return true
  end,
  english = function() return 1 end,
  toggle = function(value) return value == 2 and 1 or 2 end,
  equal = function(a, b) return a == b end,
}
_G.vim = {
  api = {
    nvim_list_uis = function() return { {} } end,
    nvim_get_mode = function() return { mode = mode } end,
    nvim_create_augroup = function() return 1 end,
    nvim_create_namespace = function() return 1 end,
    nvim_create_autocmd = function(event, opts) callbacks[event] = opts.callback end,
  },
  fn = { has = function() return 1 end },
  v = {},
  uv = {
    now = function() return 10000 end,
    new_timer = function()
      return {
        start = function(_, _, _, callback) poll = callback end,
        stop = function() end,
        close = function() end,
      }
    end,
  },
  keymap = { set = function(_, lhs, rhs) mappings[lhs] = rhs end },
  on_key = function(callback) key = callback end,
  schedule_wrap = function(callback) return callback end,
  schedule = function(callback) callback() end,
  notify = function() end,
  log = { levels = { WARN = 2 } },
}
package.loaded["config.ime_windows"] = backend
local ime = dofile("lua/config/ime.lua")
ime.setup()
assert(writes == 0, "Must not change an unverified foreground window at startup")
key("i", "i")
assert(state == 1, "First input establishes focus and switches Normal to English")
local function change(next_mode)
  vim.v.event = { old_mode = mode, new_mode = next_mode }
  mode = next_mode
  callbacks.ModeChanged()
end
change("i")
assert(state == 2, "Insert restores Chinese")
mappings["<C-Space>"]()
assert(state == 1, "Ctrl+Space switches to English")
change("n")
change("i")
assert(state == 1, "Insert remembers English")
state = 2
poll()
change("n")
assert(state == 1, "Esc switches to English")
change("i")
assert(state == 2, "Externally handled Ctrl+Space is remembered")
callbacks.FocusLost()
local before = writes
poll()
assert(writes == before, "Do not touch IME when unfocused")
state = 1
callbacks.FocusGained()
assert(state == 1, "Focus regain accepts current Insert state")
change("n")
mappings["<C-Space>"]()
assert(state == 1, "Normal toggle must remain English")
change("i")
assert(state == 2, "Normal toggle changes next Insert state")
change("n")
fail = true
change("i")
poll()
change("n")
fail = false
callbacks.FocusGained()
change("i")
assert(state == 2, "Failed restore must not overwrite remembered Chinese")
change("n")
callbacks.FocusLost()
assert(state == 2, "Leaving in Normal restores the remembered IME for other windows")
callbacks.FocusGained()
assert(state == 1, "Returning to Neovim forces English again in Normal mode")
callbacks.VimLeavePre()
assert(state == 2, "Quitting in Normal restores the remembered IME for other windows")
_G.vim = real_vim
print("IME state-machine tests: PASS")
