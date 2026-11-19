-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local function keymap(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local opts = { noremap = true, silent = true }

-- 智能行首：有缩进时跳到首个非空白字符，否则回到行首
function _G.smart_line_start()
  local line = vim.api.nvim_get_current_line()
  if line:match("^%s") then
    return "0w"
  end
  return "0"
end

-- 退出
keymap("n", "<C-q>", ":q<CR>", opts)

-- 折叠
keymap("n", "<Leader>o", "za", opts)
-- 全选
keymap("n", "<C-a>", "gg0vG$", opts)

-- ===
-- === 光标移动
-- ===
keymap("n", "<C-l>", "$", opts)
keymap("i", "<C-a>", "<C-o>$", opts)
keymap("i", "<C-i>", "<C-o>0", opts)
keymap("i", "<C-k>", "<Up>", opts)
keymap("i", "<C-j>", "<Down>", opts)
keymap("i", "<C-h>", "<Left>", opts)
keymap("i", "<C-l>", "<Right>", opts)
keymap("v", "<C-l>", "$", opts)
keymap({ "n", "v" }, "<C-h>", "v:lua.smart_line_start()", { expr = true })

-- 翻页
keymap("n", "<C-k>", "<C-U>", opts)
keymap("n", "<C-j>", "<C-D>", opts)

-- 搜索光标下的词
keymap({ "n", "x" }, "<C-r><C-w>", "*N", { desc = "Search word under cursor" })
-- 清除搜索高亮 / 重绘
keymap("n", "<leader>n", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", {
  desc = "Redraw / clear hlsearch / diff update",
})
-- 缩进后保持选区
keymap("v", ">", ">gv")
keymap("v", "<", "<gv")

-- ===
-- === 窗口管理
-- ===
keymap("n", "<Up>", ":res +5<CR>", opts)
keymap("n", "<Down>", ":res -5<CR>", opts)
keymap("n", "<Left>", ":vertical resize+5<CR>", opts)
keymap("n", "<Right>", ":vertical resize-5<CR>", opts)

-- ===
-- === Tab 管理
-- ===
keymap("n", "tu", ":tabe<CR>", opts)

-- 分屏打开终端（cd 到当前文件目录）
keymap("n", "<LEADER>.", ":set splitbelow<CR>:split<CR>:res +5<CR>:cd %:p:h|term<CR>", opts)

-- 打印当前文件完整路径
keymap("n", "\\p", ':lua print(vim.fn.expand("%:p"))<CR>', opts)

-- 用寄存器 0 粘贴（保留 yank 内容不被删除覆盖）
keymap("n", "P", '"0p', opts)
