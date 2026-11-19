-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- 输入法状态机：Normal 模式强制英文，Insert 恢复记住的状态
require("config.ime").setup()
