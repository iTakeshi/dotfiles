return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "css",
          "dockerfile",
          "git_rebase",
          "gitcommit",
          "gitignore",
          "help",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "rust",
          "sql",
          "tsx",
          "typescript",
          "vim",
          "yaml",
        },
        sync_install = false,
        auto_install = true,
        highlight = { enable = false }, -- in favor of polyglot
        indent = { enable = false }, -- in favor of polyglot
        context_commentstring = { enable = true, enable_autocmd = false },
      })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    dependencies = "nvim-treesitter",
    opts = {
      char = "│",
      char_blankline = " ",
      context_char = "│",
      show_current_context = true,
      show_current_context_start = true,
      show_end_of_line = true,
      space_char_blankline = " ",
      use_treesitter = true,
    },
  },

  {
    "sheerun/vim-polyglot",
    event = "VeryLazy",
  }
}
