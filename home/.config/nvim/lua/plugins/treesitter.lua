return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
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
    main = "ibl",
    opts = {
      indent = {
        char = "│",
      },
      scope = {
        char = "│",
      },
    },
  },

  {
    "sheerun/vim-polyglot",
    event = "VeryLazy",
  }
}
