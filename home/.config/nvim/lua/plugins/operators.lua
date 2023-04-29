return {
  {
    "cocopon/inspecthi.vim",
    keys = {
      { "<leader>h", "<cmd>Inspecthi<cr>" },
    },
    cmd = { "Inspecthi", "InspecthiShowInspector" },
  },

  {
    "echasnovski/mini.align",
    event = "VeryLazy",
    config = function()
      require("mini.align").setup()
    end,
  },

  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    config = function()
      require("mini.comment").setup({
        mappings = {
          textobject = "c",
        },
      })
    end,
  },

  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = "gsa",
          delete = "gsd",
          find = "",
          find_left = "",
          highlight = "gsh",
          replace = "gsr",
          update_n_lines = "gsn",
        },
      })
    end,
  },

  {
    "gbprod/substitute.nvim",
    event = "VeryLazy",
    config = true,
  },

  {
    "gbprod/yanky.nvim",
    event = "VeryLazy",
    config = function()
      require("yanky").setup({
        highlight = {
          timer = 100,
        },
      })
      Map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
      Map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
      Map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
      Map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
    end,
  },
}
