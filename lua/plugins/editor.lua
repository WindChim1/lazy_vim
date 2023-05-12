local Util = require("lazyvim.util")
return {

  -- disable mini.bufremove
  { "echasnovski/mini.bufremove", enabled = false },

  -- use bdelete instead
  {
    "famiu/bufdelete.nvim",
    -- stylua: ignore
    config = function()
      -- switches to Alpha dashboard when last buffer is closed
      local alpha_on_empty = vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        pattern = "BDeletePost*",
        group = alpha_on_empty,
        callback = function(event)
          local fallback_name = vim.api.nvim_buf_get_name(event.buf)
          local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
          local fallback_on_empty = fallback_name == "" and fallback_ft == ""
          if fallback_on_empty then
            require("neo-tree").close_all()
            vim.cmd("Alpha")
            vim.cmd(event.buf .. "bwipeout")
          end
        end,
      })
    end,
    keys = {
      { "<leader>bd", "<CMD>Bdelete<CR>",                desc = "Delete Buffer" },
      { "<leader>bD", "<CMD>Bdelete!<CR>",               desc = "Delete Buffer (Force)" },
      { "<leader>`",  "<Cmd>BufferLinePick<CR>",         desc = "BufferLinePick " },
      { "<leader>0",  "<Cmd>BufferLinePickClose<CR>",    desc = "BufferLinePickClose " },
      { "<leader>-",  "<Cmd>BufferLineCloseLeft<CR>",    desc = "BufferLineCloseLeft" },
      { "<leader>=",  "<Cmd>BufferLineCloseRight<CR>",   desc = "BufferLineCloseRight" },
      { "<leader>1",  "<Cmd>BufferLineGoToBuffer 1<CR>", desc = "BufferLineGoToBuffer 1" },
      { "<leader>2",  "<Cmd>BufferLineGoToBuffer 2<CR>", desc = "BufferLineGoToBuffer 2" },
      { "<leader>3",  "<Cmd>BufferLineGoToBuffer 3<CR>", desc = "BufferLineGoToBuffer 3 " },
      { "<leader>4",  "<Cmd>BufferLineGoToBuffer 4<CR>", desc = "BufferLineGoToBuffer 4 " },
      { "<leader>5",  "<Cmd>BufferLineGoToBuffer 5<CR>", desc = "BufferLineGoToBuffer 5 " },
      { "<leader>6",  "<Cmd>BufferLineGoToBuffer 6<CR>", desc = "BufferLineGoToBuffer 6 " },
      { "<leader>7",  "<Cmd>BufferLineGoToBuffer 7<CR>", desc = "BufferLineGoToBuffer 7 " },
      { "<leader>8",  "<Cmd>BufferLineGoToBuffer 8<CR>", desc = "BufferLineGoToBuffer 8 " },
      { "<leader>9",  "<Cmd>BufferLineGoToBuffer 9<CR>", desc = "BufferLineGoToBuffer 9 " },
    },
  },

  -- customize file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,              -- Close Neo-tree if it is the last window left in the tab
      filesystem = {
        follow_current_file = true,             -- This will find and focus the file in the active buffer every
        -- time the current file is changed while the tree is open.
        group_empty_dirs = true,                -- when true, empty folders will be grouped together
        hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
      },
    },
  },

  -- customize telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-dap.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "debugloop/telescope-undo.nvim" },
    },
    keys = {
      { "<leader>fh", "<cmd>Telescope oldfiles<cr>",                        desc = "find history file" },
      { "<leader>fH", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "find history file (cwd)" },
      { "<leader>fl", "<cmd>Telescope current_buffer_fuzzy_find<cr>",       desc = "find in file" },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            preview_cutoff = 0.2,
            preview_height = 0.4,
          },
          height = 0.9,
          width = 0.9,
        },
        mappings = {
          i = {
            ["<C-j>"] = function(...)
              return require("telescope.actions").move_selection_next(...)
            end,
            ["<C-k>"] = function(...)
              return require("telescope.actions").move_selection_previous(...)
            end,
            ["<C-p>"] = function(...)
              return require("telescope.actions.layout").toggle_preview(...)
            end,
          },
          n = {
            ["j"] = function(...)
              return require("telescope.actions").move_selection_next(...)
            end,
            ["k"] = function(...)
              return require("telescope.actions").move_selection_previous(...)
            end,
            ["gg"] = function(...)
              return require("telescope.actions").move_to_top(...)
            end,
            ["G"] = function(...)
              return require("telescope.actions").move_to_bottom(...)
            end,
            ["<C-p>"] = function(...)
              return require("telescope.actions.layout").toggle_preview(...)
            end,
          },
        },
      },
      extensions = {
        undo = {
          use_delta = true,
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.4,
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("dap")
      telescope.load_extension("fzf")
      telescope.load_extension("undo")
    end,
  },

  -- git conflict
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
    config = true,
  },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = function()
      local icons = require("lazyvim.config").icons
      require("symbols-outline").setup({
        symbols = {
          File = { icon = icons.kinds.File, hl = "TSURI" },
          Module = { icon = icons.kinds.Module, hl = "TSNamespace" },
          Namespace = { icon = icons.kinds.Namespace, hl = "TSNamespace" },
          Package = { icon = icons.kinds.Package, hl = "TSNamespace" },
          Class = { icon = icons.kinds.Class, hl = "TSType" },
          Method = { icon = icons.kinds.Method, hl = "TSMethod" },
          Property = { icon = icons.kinds.Property, hl = "TSMethod" },
          Field = { icon = icons.kinds.Field, hl = "TSField" },
          Constructor = { icon = icons.kinds.Constructor, hl = "TSConstructor" },
          Enum = { icon = icons.kinds.Enum, hl = "TSType" },
          Interface = { icon = icons.kinds.Interface, hl = "TSType" },
          Function = { icon = icons.kinds.Function, hl = "TSFunction" },
          Variable = { icon = icons.kinds.Variable, hl = "TSConstant" },
          Constant = { icon = icons.kinds.Constant, hl = "TSConstant" },
          String = { icon = icons.kinds.String, hl = "TSString" },
          Number = { icon = icons.kinds.Number, hl = "TSNumber" },
          Boolean = { icon = icons.kinds.Boolean, hl = "TSBoolean" },
          Array = { icon = icons.kinds.Array, hl = "TSConstant" },
          Object = { icon = icons.kinds.Object, hl = "TSType" },
          Key = { icon = icons.kinds.Key, hl = "TSType" },
          Null = { icon = icons.kinds.Null, hl = "TSType" },
          EnumMember = { icon = icons.kinds.EnumMember, hl = "TSField" },
          Struct = { icon = icons.kinds.Struct, hl = "TSType" },
          Event = { icon = icons.kinds.Event, hl = "TSType" },
          Operator = { icon = icons.kinds.Operator, hl = "TSOperator" },
          TypeParameter = { icon = icons.kinds.TypeParameter, hl = "TSParameter" },
        },
      })
    end,
  },
  {
    'mbbill/undotree',
    keys = { { "<Leader>ut", ":UndotreeToggle<CR>", desc = "UndotreeToggle" } },
    config = function()
      vim.g.undotree_DiffAutoOpen = 1
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_DiffpanelHeight = 8
      vim.g.undotree_SplitWidth = 24
      vim.cmd [[
    function g:Undotree_CustomMap()
      nmap <buffer> k <plug>UndotreeNextState
      nmap <buffer> j <plug>UndotreePreviousState
    endfunc
    ]]
    end
  },
  -- auto-save
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup {
        -- your config goes here
        -- or just leave it empty :)
      }
    end,
  },
  --
  {
    'preservim/nerdcommenter',
    config = function()
      vim.g.NERDCommentEmptyLines = 1
      vim.g.NERDTrimTrailingWhitespace = 1
    end
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      autoformat = false,
    },
  },
}
