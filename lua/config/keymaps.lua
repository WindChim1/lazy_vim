-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- local Util = require("lazyvim.util")

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
--local term_opts = { silent = true }
-- Shorten function name
--local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
-- keymap("", "<Space>", "<Nop>", opts)
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

--vim.cmd[[noremap ; :]]
-- keymap("n", ";", ":", {})
-- 保存退出
-- keymap({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
keymap("n", "<C-q>", ":q<CR>", opts)
--keymap("n", "vv", "V", opts)
-- keymap("n", "gg", "gg0", opts)

-- better up/down
-- keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

--折叠
keymap("n", "<Leader>o", "za", opts)
--全选
keymap("n", "<C-a>", "gg0vG$", opts)
-- ===
-- === 光标移动
-- ===

--keymap("n", "<Leader>k", "<C-w>k", opts)
--keymap("n", "<Leader>j", "<C-w>j", opts)
--keymap("n", "<Leader>h", "<C-w>h", opts)
--keymap("n", "<Leader>l", "<C-w>l", opts)
-- keymap("n", "K", "5k", opts)
-- keymap("n", "J", "5j", opts)
-- keymap("n", "<C-h>", "0", opts)
keymap("n", "<C-l>", "$", opts)
-- keymap("n", "W", "5w", opts)
-- keymap("n", "E", "5e", opts)
-- keymap("n", "B", "5b", opts)
keymap("i", "<C-a>", "<C-o>$", opts)
keymap("i", "<C-i>", "<C-o>0", opts)
keymap("i", "<C-k>", "<Up>", opts)
keymap("i", "<C-j>", "<Down>", opts)
keymap("i", "<C-h>", "<Left>", opts)
keymap("i", "<C-l>", "<Right>", opts)
-- keymap("v", "K", "5k", opts)
-- keymap("v", "J", "5j", opts)

keymap("v", "<C-l>", "$", opts)

-- 命令行模式移动
-- keymap("c", "<C-k>", "<Up>", {})
-- keymap("c", "<C-h>", "<Left>", {})
-- keymap("c", "<C-j>", "<Down>", {})
-- keymap("c", "<C-l>", "<Right>", {})

-- Move Lines
-- keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
-- keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
-- keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
-- keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
-- keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
-- keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

keymap(
  "n",
  "<leader>n",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

keymap({ "n", "x" }, "<C-r><C-w>", "*N", { desc = "Search word under cursor" })
-- better indenting
keymap("v", ">", ">gv")
keymap("v", "<", "<gv")

-- keymap("n", "<leader>us", function()
--   Util.toggle("spell")
-- end, { desc = "Toggle Spelling" })

--翻页
keymap("n", "<C-k>", "<C-U>", opts)
keymap("n", "<C-j>", "<C-D>", opts)
-- ===
-- === 窗口管理
-- ===
keymap("n", "r", "<nop>", opts)
keymap("n", "<leader>sk", ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>", opts)
keymap("n", "<leader>sj", ":set splitbelow<CR>:split<CR>", opts)
keymap("n", "<leader>sh", ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>", opts)
keymap("n", "<leader>sl", ":set splitright<CR>:vsplit<CR>", opts)
keymap("n", "qf", "<C-w>o", opts)
-- Resize splits with arrow keys
keymap("n", "<Up>", ":res +5<CR>", opts)
keymap("n", "<Down>", ":res -5<CR>", opts)
keymap("n", "<Left>", ":vertical resize+5<CR>", opts)
keymap("n", "<Right>", ":vertical resize-5<CR>", opts)

-- 窗口转换横竖位置
keymap("n", "<lead>srk", "<C-w>b<C-w>K", opts)
keymap("n", "<lead>srh", "<C-w>b<C-w>H", opts)
keymap("n", "<Leader>q", "<C-w>j:q<CR>", opts)
-- ===
-- === Tab management
-- ===
keymap("n", "tu", ":tabe<CR>", opts)
-- keymap("n", "tU", ":tab split<CR>", opts)
-- keymap("n", "th", ":-tabnext<CR>", opts)
-- keymap("n", "tl", ":+tabnext<CR>", opts)
-- keymap("n", "tmh", ":-tabmove<CR>", opts)
-- keymap("n", "tml", ":+tabmove<CR>", opts)

-- buffers
-- if Util.has("bufferline.nvim") then
--   keymap("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
--   keymap("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
-- else
--   keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
--   keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
-- end

keymap("n", "<LEADER>.", ":set splitbelow<CR>:split<CR>:res +5<CR>:term<CR>", opts)
keymap("n", "<LEADER>/", ":set splitbelow<CR>:split<CR>:res +5<CR>:cd %:p:h|term<CR>", opts)
-- keymap({ "i", "v", "t" }, "<esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

-- lazygit
-- keymap("n", "<leader>lg", function()
--   Util.float_term({ "lazygit" }, { cwd = Util.get_root(), esc_esc = false })
-- end, { desc = "Lazygit (root dir)" })

keymap("n", "\\p", ':lua print(vim.fn.expand("%:p"))<CR>', opts)

keymap("n", "P", '"0p', opts)

function CompileRunGcc()
  vim.cmd("w")
  if vim.bo.filetype == "c" then
    vim.fn.system("g++ % -o %<")
    vim.fn.system("time ./%<")
  elseif vim.bo.filetype == "cpp" then
    vim.cmd("set splitbelow")
    vim.fn.system("g++ -std=c++11 % -Wall -o %<")
    vim.cmd("sp")
    vim.cmd("res -15")
    vim.fn.system("term ./%<")
  elseif vim.bo.filetype == "python" then
    vim.cmd("set splitbelow")
    vim.cmd("sp")
    vim.fn.termopen("python3 %")
  elseif vim.bo.filetype == "markdown" then
    vim.cmd("MarkdownPreview")
  elseif vim.bo.filetype == "sh" then
    vim.fn.system("time bash %")
  elseif vim.bo.filetype == "html" then
    vim.fn.system(g.mkdp_browser .. " % &")
  elseif vim.bo.filetype == "go" then
    vim.cmd("set splitbelow")
    vim.cmd("sp")
    vim.cmd("res -15")
    vim.fn.termopen("go run %")
  elseif vim.bo.filetype == "vue" then
    vim.cmd("set splitbelow")
    vim.cmd("sp")
    vim.fn.termopen("npm run build")
  elseif vim.bo.filetype == "rust" then
    vim.cmd("set splitbelow")
    vim.cmd("sp")
    vim.cmd("res -15")
    vim.cmd("ter cargo run")
    --vim.fn.system('cargo run')
    --vim.fn.system('rustc % -o %<')
    --vim.fn.system('time ./%<')
  end
end
keymap("n", "<leader>r", ":lua CompileRunGcc()<CR>", { noremap = true, silent = true })

function Custom_keymap()
  local line = vim.api.nvim_get_current_line()
  if string.match(line, "^%s") then
    return "0w"
  else
    return "0"
  end
end

keymap("n", "<C-h>", "v:lua.Custom_keymap()", { expr = true })
keymap("v", "<C-h>", "v:lua.Custom_keymap()", { expr = true })
