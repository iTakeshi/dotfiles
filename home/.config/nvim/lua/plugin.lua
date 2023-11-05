local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  ui = {
    border = "rounded",
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  spec = {
    { import = "plugins" },

    {
      "folke/noice.nvim",
      dependencies = {
        "MunifTanjim/nui.nvim",
        {
          "rcarriga/nvim-notify",
          lazy = true,
          opts = {
            stages = "slide",
          },
        },
      },
      config = true,
    },

    {
      "lewis6991/gitsigns.nvim",
      event = "VeryLazy",
      opts = {
        current_line_blame_opts = {
          virt_text_pos = "right_align",
          delay = 300,
        },
        on_attach = function()
          Map("n", "<plug>(my-toggle)b", require("gitsigns").toggle_current_line_blame)
        end,
      },
    },

    {
      "nvim-tree/nvim-web-devicons",
      lazy = true,
    },

    {
      "cappyzawa/trim.nvim",
      config = function()
        require("trim").setup()
        Map("n", "<plug>(my-toggle)W", require("trim.trimmer").toggle)
      end,
    },

    -- textobj
    -- default text objexts are: wWspt(b){B}[]<>`'"

    {
      "kana/vim-textobj-user",
      event = "VeryLazy",
    },
    {
      "kana/vim-textobj-line", -- l
      dependencies = { "vim-textobj-user" },
      event = "VeryLazy",
    },
    {
      "mattn/vim-textobj-url", -- u
      dependencies = { "vim-textobj-user" },
      event = "VeryLazy"
    },
    {
      "sgur/vim-textobj-parameter", -- ,
      dependencies = { "vim-textobj-user" },
      event = "VeryLazy",
    },

    -- colorscheme

    {
      "sainnhe/sonokai",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd.colorscheme("sonokai")
      end,
    }
  },
})
