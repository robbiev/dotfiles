return {
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  { "tpope/vim-sleuth" },
  { "github/copilot.vim" },
  { "lambdalisue/vim-suda" },
  {
    "folke/tokyonight.nvim",
    config = function()
      vim.cmd.colorscheme("tokyonight-day")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>b", builtin.buffers, { noremap = true })
      vim.keymap.set("n", "<leader>t", builtin.tags, { noremap = true })
      vim.keymap.set("n", "<leader>f", builtin.find_files, { noremap = true })
      vim.keymap.set("n", "<leader>g", builtin.live_grep, { noremap = true })
      vim.keymap.set("n", "<leader>h", builtin.help_tags, { noremap = true })

      require("telescope").setup({
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob",
            "!**/.git/*",
          },
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
      })
    end,
  },
  {
    "airblade/vim-rooter",
    config = function()
      vim.g.rooter_manual_only = 1
      vim.g.rooter_change_directory_for_non_project_files = "current"
      vim.g.rooter_patterns = { "Makefile", ".git/" }
      vim.keymap.set("n", "<leader>r", ":Rooter<CR>", { noremap = true })
    end,
  },
  {
    "stevearc/conform.nvim",
    config = function()
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          go = { "goimports" },
          zig = { "zigfmt" },
          lua = { "stylua" },
          nix = { "alejandra" },
          javascript = { "prettier" },
        },
        format_on_save = {
          async = true,
        },
      })
      conform.formatters.goimports = {
        prepend_args = { "-local", "github.com/monzo" },
      }
    end,
  },
  {
    "ghostty-macos",
    dir = "/Applications/Ghostty.app/Contents/Resources/vim/vimfiles/",
    lazy = false,
    cond = function()
      return vim.fn.has("macunix") and vim.fn.executable("ghostty") == 1
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "vimdoc",
          "javascript",
          "typescript",
          "c",
          "lua",
          "go",
          "gomod",
          "gosum",
          "bash",
          "zig",
        },
        -- brew install tree-sitter
        auto_install = true,
        indent = {
          enable = true,
        },
        highlight = {
          enable = true,
        },
      })
    end,
  },
  -- TODO investigate go plugins
  -- https://github.com/fatih/vim-go
  -- https://github.com/olexsmir/gopher.nvim
  -- https://github.com/crispgm/nvim-go
  -- https://github.com/ray-x/go.nvim
}
