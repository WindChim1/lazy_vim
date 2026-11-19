return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- 全局 LSP 键位覆盖（对所有 LSP server 生效）：
        -- LazyVim 默认在 LSP 附着时把插入模式 <C-k> 映射为 Signature Help，
        -- 该映射是 buffer-local，优先级高于 keymaps.lua 的全局 <C-k> = <Up>。
        -- 这里禁用它，让 <C-k> 保持光标上移；签名帮助仍可用普通模式的 gK
        ["*"] = {
          keys = {
            { "<c-k>", false, mode = "i" },
          },
        },
      },
    },
  },
}
