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
  -- =========================================================
  -- 4. 【新增】 配置 blink.cmp 进行过滤
  -- =========================================================

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- 【核心修改】更健壮的检查函数
      local function is_in_rust_view_macro()
        local buf = vim.api.nvim_get_current_buf()
        -- 1. 检查 buffer 是否有效，防止无效引用
        if not vim.api.nvim_buf_is_valid(buf) then
          return false
        end

        -- 2. 使用 pcall 保护 get_node，防止 TreeSitter 同步延迟导致的崩溃
        -- 如果获取节点失败，直接返回 false
        local ok, node = pcall(vim.treesitter.get_node)
        if not ok or not node then
          return false
        end

        -- 3. 循环向上查找
        while node do
          local type = node:type()
          if type == "macro_invocation" then
            -- 获取宏名字节点
            local name_node = node:child(0)
            if name_node then
              -- 4. 获取文本也加 pcall，双重保险
              local text_ok, text = pcall(vim.treesitter.get_node_text, name_node, buf)
              if text_ok and text == "view" then
                return true
              end
            end
          end
          node = node:parent()
        end
        return false
      end

      opts.sources = opts.sources or {}
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.lsp = opts.sources.providers.lsp or {}

      local old_transform = opts.sources.providers.lsp.transform_items

      opts.sources.providers.lsp.transform_items = function(ctx, items)
        if old_transform then
          items = old_transform(ctx, items)
        end

        if vim.bo.filetype ~= "rust" then
          return items
        end

        -- 在这里调用安全的函数
        -- 即使 TreeSitter 报错，函数只会返回 false，不会让编辑器报错
        local in_view_macro = is_in_rust_view_macro()
        local filtered_items = {}

        for _, item in ipairs(items) do
          local keep = true
          if item.client_id then
            local client = vim.lsp.get_client_by_id(item.client_id)
            if client and client.name == "emmet_language_server" then
              if not in_view_macro then
                keep = false
              end
            end
          end
          if keep then
            table.insert(filtered_items, item)
          end
        end

        return filtered_items
      end
    end,
  },
}
