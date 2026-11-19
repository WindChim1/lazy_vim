return {
  {
    "saghen/blink.cmp",
    -- 禁用补全插件占用的按键：
    -- <C-Space> 留给输入法切换；<C-k> 默认弹出 LSP 签名帮助
    opts = {
      keymap = {
        ["<C-space>"] = false,
      },
    },
  },
}
