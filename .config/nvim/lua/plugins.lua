return {
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  { "github/copilot.vim" },
  { "lambdalisue/vim-suda" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lua",
    },
    enabled = true,
    config = function()
      local cmp = require("cmp")
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      cmp.setup({
        completion = {
          autocomplete = false,
        },
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lua" },
        }),
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lua = "[Neovim]",
              buffer = "[Buffer]",
            })[entry.source.name]
            return vim_item
          end,
        },
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    config = function()
      vim.cmd.colorscheme("tokyonight-day")
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
      vim.keymap.set("n", "<leader>t", require("fzf-lua").tags, { noremap = true })
      vim.keymap.set("n", "<leader>f", require("fzf-lua").files, { noremap = true })
      vim.keymap.set("n", "<leader>g", require("fzf-lua").live_grep_native, { noremap = true })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      -- local builtin = require("telescope.builtin")
      -- vim.keymap.set("n", "<leader>b", builtin.buffers, { noremap = true })
      -- vim.keymap.set("n", "<leader>t", builtin.tags, { noremap = true })
      -- vim.keymap.set("n", "<leader>f", builtin.find_files, { noremap = true })
      -- vim.keymap.set("n", "<leader>g", builtin.live_grep, { noremap = true })
      -- vim.keymap.set("n", "<leader>h", builtin.help_tags, { noremap = true })

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
          terraform = { "terraform_fmt" },
          nix = { "alejandra" },
          javascript = { "prettier" },
          python = { "ruff_format", "ruff_organize_imports" },
          rust = { "rustfmt" },
        },
        format_after_save = {},
      })
      conform.formatters.goimports = {
        prepend_args = { "-local", "github.com/monzo" },
      }
    end,
  },
  {
    "wearedev",
    dir = "~/src/github.com/monzo/wearedev/tools/editors/nvim/nvim-monzo",
    cond = function(plugin)
      local stat = vim.loop.fs_stat(plugin.dir)
      return stat and stat.type == "directory"
    end,
    config = function()
      vim.keymap.set("n", "<leader>mc", require("monzo").jump_to_component, { noremap = true })
      vim.keymap.set("n", "<leader>mt", require("monzo").jump_to_tool, { noremap = true })
      vim.keymap.set("n", "<leader>ml", require("monzo").jump_to_library, { noremap = true })
      vim.keymap.set("n", "<leader>md", require("monzo").jump_to_downstream, { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>mh", "", {
        noremap = true,
        silent = true,
        callback = function()
          -- Call handlertool.
          local file_src_path_abs = vim.fn.expand("%:p")
          local file_src_line = vim.fn.line(".")
          local file_src_col = vim.fn.col(".")
          local handlertool_out = vim.fn.system(
            "handlertool " .. vim.fn.shellescape(file_src_path_abs .. ":" .. file_src_line .. ":" .. file_src_col)
          )

          -- Parse handlertool output.
          local file_dst_path_abs, file_dst_line, file_dst_col = string.match(handlertool_out, "([^:]+):(%d+):(%d+)")

          -- Jump to the destination.
          vim.cmd("e " .. file_dst_path_abs)
          vim.fn.setpos(".", { vim.api.nvim_get_current_buf(), tonumber(file_dst_line), tonumber(file_dst_col), 0 })
          vim.cmd("normal! zz")
        end,
      })
    end,
  },
  {
    "ghostty-macos",
    dir = "/Applications/Ghostty.app/Contents/Resources/vim/vimfiles/",
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
