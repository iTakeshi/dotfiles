return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-web-devicons",
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
      })
    end,
  },
}
