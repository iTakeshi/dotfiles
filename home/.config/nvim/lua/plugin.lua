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
  change_detection = {
    enabled = false,
  },
  spec = {
    { import = "plugins" },

    {
      "nvim-tree/nvim-web-devicons",
      lazy = true,
    },

    {
      "ntpeters/vim-better-whitespace",
      config = function()
        vim.g.strip_whitespace_on_save = 1
        vim.g.strip_whitespace_confirm = 0
        vim.g.strip_whitelines_at_eof = 1
        vim.g.show_spaces_that_precede_tabs = 1
        local function toggle()
          vim.cmd("ToggleStripWhitespaceOnSave")
          if vim.b["strip_whitespace_on_save"] == 1 then -- use brackets to avoid "undefined-field" diagnostics
            print("  stripwhitespace")
          else
            print("nostripwhitespace")
          end
        end
        Map("n", "<plug>(my-toggle)W", toggle)
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
      config = function()
        vim.cmd.colorscheme("sonokai")
      end,
    }
  },
})
