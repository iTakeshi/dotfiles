return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
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
    opts = {},
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  {
    "cocopon/inspecthi.vim",
    keys = {
      { "<leader>h", "<cmd>Inspecthi<cr>", desc = "Inspect highlight" },
    },
    cmd = { "Inspecthi", "InspecthiShowInspector" },
  },
}
