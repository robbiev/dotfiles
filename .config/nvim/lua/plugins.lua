return {
  { "tpope/vim-commentary" },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  { "tpope/vim-sleuth" },
  { "github/copilot.vim" },
  { "ziglang/zig.vim" },
  { 
    "lifepillar/vim-solarized8",
    branch = "neovim",
    config = function()
      vim.g.solarized_termtrans=1
      vim.opt.background = "dark"
      vim.cmd.colorscheme "solarized8"
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set("n", "<leader>b", builtin.buffers, {noremap = true})
      vim.keymap.set("n", "<leader>t", builtin.tags, {noremap = true})
      vim.keymap.set("n", "<leader>f", builtin.find_files, {noremap = true})
      vim.keymap.set("n", "<leader>g", builtin.live_grep, {noremap = true})
      vim.keymap.set("n", "<leader>h", builtin.help_tags, {noremap = true})

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
          }
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
      })
    end
  },
  {
    "airblade/vim-rooter",
    config = function()
      vim.g.rooter_manual_only = 1
      vim.g.rooter_change_directory_for_non_project_files = "current"
      vim.g.rooter_patterns={"Makefile", ".git/"}
      vim.keymap.set("n", "<leader>r", ":Rooter<CR>", {noremap = true})
    end
  },
  {
    "fatih/vim-go",
    config = function()
      vim.g.go_highlight_functions=1
      vim.g.go_highlight_methods=1
      vim.g.go_highlight_structs=1
      vim.g.go_fmt_command="goimports"
      vim.g.go_fmt_options = {
        goimports = "-local github.com/monzo",
      }
      vim.g.go_version_warning = 0
      vim.g.go_def_mode = "gopls"
      vim.g.go_info_mode = "gopls"

      -- Fix losing fold state on save
      -- https://github.com/fatih/vim-go/issues/502
      vim.g.go_fmt_experimental = 1
    end,
  },
  {
    "ghostty-macos",
    dir = "/Applications/Ghostty.app/Contents/Resources/vim/vimfiles/",
    lazy = false,
    cond = function()
      return vim.fn.has('macunix') and vim.fn.executable("ghostty") == 1
    end,
  },
}
