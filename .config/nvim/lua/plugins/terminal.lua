return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      -- <c-t> is taken by Ghostty (new_tab); use <c-s-t> (Ghostty unbinds ctrl+shift+t)
      { "<c-s-t>", "<cmd>ToggleTerm<cr>", mode = "n" },
    },
    opts = {
      direction = "float",
      float_opts = {
        border = "rounded",
      },
      on_open = function(term)
        vim.keymap.set("t", "<c-s-t>", "<cmd>ToggleTerm<cr>", { buffer = term.bufnr })
        vim.keymap.set("t", "<Esc><Esc>", "<cmd>ToggleTerm<cr>", { buffer = term.bufnr })
        vim.keymap.set("t", "<Esc>", [[<c-\><c-n>]], { buffer = term.bufnr })
      end,
    },
  },
}
