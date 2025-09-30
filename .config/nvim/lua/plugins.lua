return {
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" },
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
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        extra_scp_args = { "-O" }, -- Use the legacy SCP protocol for now, as I have some old servers
        keymaps = {
          ["<C-h>"] = false,
          ["<C-l>"] = false,
        },
      })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
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
          enable = false,
        },
      })
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
          terraform = { "terraform_fmt" },
          nix = { "alejandra" },
          javascript = { "prettier" },
          python = { "ruff_format", "ruff_organize_imports" },
          rust = { "rustfmt" },
        },
        format_after_save = {},
      })
      conform.formatters.goimports = {
        prepend_args = { "-local", "github.com/robbiev" },
      }
    end,
  },
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup({
        "telescope",
        winopts = {
          fullscreen = true,
        },
        files = {
          cwd_prompt = false,
        },
      })
      vim.keymap.set("n", "<leader>b", require("fzf-lua").buffers, { noremap = true })
      vim.keymap.set("n", "<leader>tt", require("fzf-lua").tags, { noremap = true })
      vim.keymap.set("n", "<leader>tb", require("fzf-lua").btags, { noremap = true })
      vim.keymap.set("n", "<leader>tg", require("fzf-lua").tags_live_grep, { noremap = true })
      vim.keymap.set("n", "<leader>tw", require("fzf-lua").tags_grep_cword, { noremap = true })
      vim.keymap.set("n", "<leader>f", require("fzf-lua").files, { noremap = true })
      vim.keymap.set("n", "<leader>gg", require("fzf-lua").live_grep_native, { noremap = true })
      vim.keymap.set("n", "<leader>gw", require("fzf-lua").grep_cword, { noremap = true })
    end,
  },
}
