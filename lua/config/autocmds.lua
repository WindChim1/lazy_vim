-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- This file is automatically loaded by plugins.init
-- vim.cmd("Copilot disable")

--
--
--- 定义 fcitx 命令
local fcitx_cmd = vim.fn.executable("fcitx5-remote") == 1 and "fcitx5-remote" or "fcitx-remote"

-- 在退出插入模式时切换到英文
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    vim.b.fcitx = tonumber(vim.fn.system(fcitx_cmd))
    vim.fn.system(fcitx_cmd .. " -c")
  end,
})

-- 进入插入模式时恢复上次的输入源
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    if vim.b.fcitx and vim.b.fcitx == 2 then
      vim.fn.system(fcitx_cmd .. " -o")
    end
  end,
})
