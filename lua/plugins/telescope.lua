local Util = require("lazyvim.util")
return {
  "nvim-telescope/telescope.nvim",

  keys = {
    -- disable the keymap to grep files
    { "<leader>/", false },
    { "<leader>,", false },
    { "<leader>:", false },
    { "<leader><space>", false },
    { "<leader>fr", false },
    { "<leader>fR", false },
    { "<leader>sa", false },
    { "<leader>sb", false },
    { "<leader>sc", false },
    { "<leader>sC", false },
    { "<leader>sd", false },
    { "<leader>sD", false },
    { "<leader>sg", false },
    { "<leader>sG", false },
    { "<leader>sk", false },
    { "<leader>sm", false },
    { "<leader>sM", false },
    { "<leader>so", false },
    { "<leader>sR", false },
    { "<leader>sw", false },
    { "<leader>sW", false },

    -- change a keymap
    -- add a keymap to browse plugin files
    { "<Leader>fg", "<cmd>Telescope live_grep <cr>", desc = "Grep" },
    { "<leader>fw", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy Find" },
    { "<leader>fh", "<cmd>Telescope oldfiles<cr>", desc = "Old Files" },
    { "<Leader>fl", "<cmd>Telescope lsp_document_symbols <CR>", desc = "" },
    { "<leader>fc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
    { "<leader>fo", "<cmd>Telescope vim_options<cr>", desc = "Options" },
    { "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
    {
      "<leader>fs",
      Util.telescope("colorscheme", { enable_preview = true }),
      desc = "Colorscheme with preview",
    },
    {
      "<leader>fp",
      function()
        require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
      end,
      desc = "Find Plugin File",
    },
  },
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = function(...)
            return require("telescope.actions").move_selection_next(...)
          end,
          ["<C-k>"] = function(...)
            return require("telescope.actions").move_selection_previous(...)
          end,
        },
      },
    },
  },
}
