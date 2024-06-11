return {
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
    "junegunn/fzf",
    build = function()
      vim.fn['fzf#install']()
    end,
  },
  { "junegunn/fzf.vim" },
  { "tpope/vim-commentary" },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  { "tpope/vim-sleuth" },
  {
    -- :Rooter sets the working directory to the nearest project
    "airblade/vim-rooter",
    config = function()
      vim.g.rooter_manual_only=1
      vim.g.rooter_patterns={"Makefile", ".git/"}
    end
  },
  { 
    "ludovicchabant/vim-gutentags" ,
    config = function()
      vim.g.gutentags_cache_dir="~/.vim/gutentags"
      vim.g.gutentags_project_root={"Makefile", ".gutentags"}
      -- set statusline+=%{gutentags#statusline()}
    end

  },
  { "jmckiern/vim-venter" },
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

  -- Lisp
  { 
    "guns/vim-sexp",
    config = function()
      vim.g.sexp_filetypes = "clojure,scheme,lisp,fennel"
    end
  },
  { "tpope/vim-sexp-mappings-for-regular-people" },
  { "Olical/aniseed",
    branch = "master",
    config = function()
      require("aniseed.env").init()
    end,
  },
  { "bakpakin/fennel.vim" },
  { "Olical/conjure", tag = "v4.13.0" },
  {
    "ghostty-macos",
    dir = "/Applications/Ghostty.app/Contents/Resources/vim/vimfiles/",
    lazy = false,
    cond = function()
      return vim.fn.has('macunix') and vim.fn.executable("ghostty") == 1
    end,
  },
}
