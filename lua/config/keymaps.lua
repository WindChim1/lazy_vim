-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
if vim.fn.executable("gitui") == 1 then
  -- gitui instead of lazygit
  vim.keymap.set("n", "<leader>gg", function()
    require("lazyvim.util").float_term({ "gitui" })
  end, { desc = "gitui (cwd)" })
  vim.keymap.set("n", "<leader>gG", function()
    require("lazyvim.util").float_term({ "gitui" }, { cwd = require("lazyvim.util").get_root() })
  end, { desc = "gitui (root dir)" })
end

if vim.fn.executable("btop") == 1 then
  -- btop
  vim.keymap.set("n", "<leader>xb", function()
    require("lazyvim.util").float_term({ "btop" })
  end, { desc = "btop" })
end

--========================================================================
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap('n', '<C-k>', '5k', opts)
keymap('n', '<C-j>', '5j', opts)
keymap('n', '<C-h>', '0', opts)
keymap('n', '<C-l>', '$', opts)
keymap('n', 'W', '5w', opts)
keymap('n', 'E', '5e', opts)
keymap('n', 'B', '5b', opts)
keymap('i', '<C-a>', '<ESC>A', opts)
keymap('i', '<C-h>', '<Left>', opts)
keymap('v', 'K', '5k', opts)
keymap('i', '<C-l>', '<Right>', opts)
keymap('v', '<C-k>', '5k', opts)
keymap('v', '<C-j>', '5j', opts)
keymap('v', '<C-h>', '0', opts)
keymap('v', '<C-l>', '$', opts)

keymap('n', 'J', '5j', opts)
keymap('n', 'vv', 'V', opts)


vim.cmd(
  [[
cnoremap <C-a>  <Home>
cnoremap <C-e>  <End>
cnoremap <C-k>  <Up>
cnoremap <C-j>  <Down>
cnoremap <C-h>  <Left>
cnoremap <C-l>  <Right>
]]
)
--翻页
keymap('n', '<C-K>', '<C-U>', opts)
keymap('n', '<C-J>', '<C-D>', opts)

keymap('n', '<LEADER>.', ':set splitbelow<CR>:split<CR>:res +5<CR>:term<CR>a', opts)

-- lazy
keymap("n", "<leader>lz", "<cmd>:Lazy<cr>", { desc = "Lazy" })

keymap('n', '<leader>sk', ':set nosplitbelow<CR>:split<CR>:set splitbelow<CR>', opts)
keymap('n', '<leader>sj', ':set splitbelow<CR>:split<CR>', opts)
keymap('n', '<leader>sh', ':set nosplitright<CR>:vsplit<CR>:set splitright<CR>', opts)
keymap('n', '<leader>sl', ':set splitright<CR>:vsplit<CR>', opts)
keymap('n', '<leader>qf', '<C-w>o', opts)
keymap('n', '<Leader>k', '<C-w>k', opts)
keymap('n', '<Leader>j', '<C-w>j', opts)
keymap('n', '<Leader>h', '<C-w>h', opts)
keymap('n', '<Leader>l', '<C-w>l', opts)
keymap('n', 'Q', ':q<CR>', opts)
-- Resize splits with arrow keys
keymap('n', '<Up>', ':res +5<CR>', opts)
keymap('n', '<Down>', ':res -5<CR>', opts)
keymap('n', '<Left>', ':vertical resize+5<CR>', opts)
keymap('n', '<Right>', ':vertical resize-5<CR>', opts)

--全选
vim.cmd [[nmap <C-a> gg0vG$]]


keymap('n', '<leader>tu', ':tabe<CR>', opts)
keymap("n", "<leader>0", "<cmd>tablast<cr>", { desc = "Last Tab" })
keymap("n", "<leader>1", "<cmd>tabfirst<cr>", { desc = "First Tab" })
keymap("n", "<leader>tl", "<cmd>tabnext<cr>", { desc = "Next Tab" })
keymap("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Close Tab" })
keymap("n", "<leader>th", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })


--替换
vim.cmd [[
noremap \s :%s//g<left><left>
noremap \p :echo expand('%:p')<CR>
]]



-- 设置重新进入文件时，光标留在上次退出的地方
vim.cmd [[
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]]
-- 退出插入模式时自动切换到英文
vim.cmd [[
let s:fcitx_cmd = executable("fcitx5-remote") ? "fcitx5-remote" : "fcitx-remote"
autocmd InsertLeave * let b:fcitx = system(s:fcitx_cmd) | call system(s:fcitx_cmd.' -c')
]]
-- 进入插入模式时为上次插入模式的输入法
vim.cmd [[
"autocmd InsertEnter * if exists('b:fcitx') && b:fcitx == 2 | call system(s:fcitx_cmd.' -o') | endif
]]
