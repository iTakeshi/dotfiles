return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "biome",
        "lua_ls",
        "pyright",
        "ruff",
        "rust_analyzer",
        "terraformls",
        "tflint",
        "tinymist",
        "ts_ls",
        "vacuum",
        "yamlls",
      },
    },
  },

  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.*",
    opts = {
      completion = {
        list = {
          selection = { preselect = false },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100,
        },
        accept = {
          auto_brackets = { enabled = false },
        },
      },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp      = { score_offset = 1000 },
          path     = { score_offset = 300 },
          buffer   = { score_offset = 200, min_keyword_length = 3 },
          snippets = { score_offset = -1 },
        },
      },
      appearance = {
        nerd_font_variant = "mono",
        use_nvim_cmp_as_default = true,
      },
    },
    opts_extend = { "sources.default" },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      -- Configure diagnostics display
      vim.diagnostic.config({
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN]  = "▲",
            [vim.diagnostic.severity.HINT]  = "⚑",
            [vim.diagnostic.severity.INFO]  = "»",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
      })

      -- Per-buffer LSP keymaps via LspAttach (Neovim 0.11 recommended pattern)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("MyLspAttach", { clear = true }),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          Map("n", "gf",         vim.lsp.buf.format, opts)
          Map("n", "gd",         vim.lsp.buf.definition, opts)
          Map("n", "g]",         function() vim.diagnostic.jump({ count = 1,  float = true }) end, opts)
          Map("n", "g[",         function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
          Map("n", "<leader>ih", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, opts)
        end,
      })

      vim.api.nvim_exec_autocmds("FileType", {})
    end,
  },

  {
    "RubixDev/mason-update-all",
    dependencies = "mason.nvim",
    cmd = "MasonUpdateAll",
    opts = {},
  },

  -- LSP 進捗表示
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },

}
