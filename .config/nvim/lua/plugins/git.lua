return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      -- `<plug>(my-toggle)` prefix (`T`) is defined in lua/keymaps.lua, loaded before plugins
      { "<plug>(my-toggle)b", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle git blame" },
    },
    opts = {
      current_line_blame_opts = {
        virt_text_pos = "right_align",
        delay = 300,
      },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",             desc = "Diff working tree" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",    desc = "File history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",      desc = "Repo history" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>",            desc = "Close diffview" },
    },
    opts = {
      view = {
        default = { layout = "diff2_horizontal" },
      },
    },
  },

  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<c-g>", "<cmd>LazyGitToggle<cr>", mode = "n", desc = "Toggle lazygit" },
    },
    config = function()
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*lazygit*",
        callback = function(ev)
          vim.keymap.set("t", "<c-g>", "<cmd>LazyGitToggle<cr>", { buffer = ev.buf })
          vim.keymap.set("t", "<Esc><Esc>", "<cmd>LazyGitToggle<cr>", { buffer = ev.buf })
          vim.keymap.set("t", "<Esc>", [[<c-\><c-n>]], { buffer = ev.buf })
        end,
      })
    end,
  },
}
