return {
  -- align
  {
    "echasnovski/mini.align",
    keys = {
      { "ga", mode = { "n", "x" }, desc = "Align" },
      { "gA", mode = { "n", "x" }, desc = "Align with preview" },
    },
    opts = {},
  },

  -- comment
  {
    "echasnovski/mini.comment",
    keys = {
      { "gc", mode = { "n", "x" }, desc = "Comment toggle" },
      { "gcc", desc = "Comment line" },
    },
    opts = {
      mappings = {
        textobject = "c",
      },
    },
  },

  -- surround
  {
    "echasnovski/mini.surround",
    keys = {
      { "gsa", mode = { "n", "x" }, desc = "Add surrounding" },
      { "gsd", desc = "Delete surrounding" },
      { "gsr", desc = "Replace surrounding" },
      { "gsh", desc = "Highlight surrounding" },
      { "gsn", desc = "Update n lines" },
    },
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "",
        find_left = "",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  -- yank ring（履歴取りこぼし防止のため VeryLazy で早期ロード）
  {
    "gbprod/yanky.nvim",
    event = "VeryLazy",
    keys = {
      { "p",  "<Plug>(YankyPutAfter)",   mode = { "n", "x" }, desc = "Put after" },
      { "P",  "<Plug>(YankyPutBefore)",  mode = { "n", "x" }, desc = "Put before" },
      { "gp", "<Plug>(YankyGPutAfter)",  mode = { "n", "x" }, desc = "Put after (gp)" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put before (gP)" },
    },
    opts = {
      highlight = { timer = 100 },
    },
  },

  -- trim trailing whitespace on save
  {
    "cappyzawa/trim.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      -- `<plug>(my-toggle)` prefix (`T`) is defined in lua/keymaps.lua, loaded before plugins
      { "<plug>(my-toggle)W", function() require("trim.trimmer").toggle() end, desc = "Toggle trim on save" },
    },
    opts = {},
  },

  -- textobj
  -- default text objects are: wWspt(b){B}[]<>`'"
  {
    "kana/vim-textobj-user",
    lazy = true,
  },
  {
    "kana/vim-textobj-line", -- l
    dependencies = { "kana/vim-textobj-user" },
    event = "VeryLazy",
  },
  {
    "mattn/vim-textobj-url", -- u
    dependencies = { "kana/vim-textobj-user" },
    event = "VeryLazy",
  },
  {
    "sgur/vim-textobj-parameter", -- ,
    dependencies = { "kana/vim-textobj-user" },
    event = "VeryLazy",
  },
}
