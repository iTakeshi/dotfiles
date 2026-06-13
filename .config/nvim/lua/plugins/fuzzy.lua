return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<c-p>",      function() require("fzf-lua").files() end,                    desc = "Find files" },
      { "<leader>fb", function() require("fzf-lua").buffers() end,                  desc = "Find buffers" },
      { "<leader>fg", function() require("fzf-lua").live_grep() end,                desc = "Live grep" },
      { "<leader>fs", function() require("fzf-lua").lsp_document_symbols() end,     desc = "Document symbols" },
      { "<leader>fr", function() require("fzf-lua").lsp_references() end,           desc = "LSP references" },
      { "<leader>fd", function() require("fzf-lua").diagnostics_document() end,     desc = "Document diagnostics" },
    },
    opts = {
      winopts = {
        border = "rounded",
        height = 0.85,
        width = 0.85,
        preview = {
          layout = "vertical",
          vertical = "down:40%",
        },
      },
      fzf_opts = {
        ["--layout"] = "reverse",
      },
    },
  },
}
