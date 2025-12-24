return {
  -- 1. 配置 LSP (Emmet)
  -- 让 Emmet 支持 Rust 文件，解决 view! 宏里写标签没提示的问题
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- 确保 servers 表存在
      opts.servers = opts.servers or {}

      -- 配置 emmet_language_server
      opts.servers.emmet_language_server = {
        -- 【关键点】把 "rust" 加入到支持的文件类型列表中
        filetypes = {
          "css",
          "html",
          "rust",
        },
        init_options = {
          includeLanguages = {},
          excludeLanguages = {},
          showAbbreviationSuggestions = true,
          showExpandedAbbreviation = "always",
          showSuggestionsAsSnippets = false,
        },
      }
    end,
  },

  -- 2. 配置格式化 (Conform)
  -- 让保存时自动运行 leptosfmt 整理 view! 宏的缩进
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      -- 对 rust 文件，按顺序执行格式化
      -- 1. leptosfmt (专门处理 view! 宏)
      -- 2. rustfmt (处理标准 Rust 代码)
      -- 3. lsp (最后兜底，通常不需要)
      opts.formatters_by_ft.rust = { "leptosfmt", "rustfmt" }
    end,
  },

  -- 3. (可选) 增强高亮支持
  -- 即使有了 rustaceanvim，有时候 view! 里的标签颜色还是不对
  -- 这是一个简单的 Treesitter 注入配置
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "html", "css", "rust" })
      end
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        default_settings = {
          -- 这里是 rust-analyzer 的具体设置
          ["rust-analyzer"] = {
            procMacro = {
              ignored = {
                -- 告诉 analyzer 忽略 leptos_macro 里的 server 宏
                -- 这样它就不会因为宏展开过于复杂而报错
                ["leptos_macro"] = { "server" },
              },
            },
            -- (可选) 如果你觉得宏展开太慢卡顿，可以限制一下
            diagnostics = {
              disabled = { "unresolved-proc-macro" },
            },
          },
        },
      },
    },
  },
}
