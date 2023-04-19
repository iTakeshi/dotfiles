return {
  {
    "neovim/nvim-lspconfig",
    event = "CursorHold",
    dependencies = {
      { "folke/neodev.nvim", config = true },
      { "williamboman/mason-lspconfig.nvim", dependencies = "mason.nvim" },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")
      local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
      mason_lspconfig.setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "tsserver",
          "yamlls",
        },
      })
      mason_lspconfig.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = cmp_capabilities,
          })
        end,
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
              },
            },
          })
        end,
        ["pyright"] = function()
          local venv_path = vim.trim(vim.fn.system("poetry config virtualenvs.path"))
          local venv_name = vim.trim(vim.fn.system("poetry env list"))

          local python_path = "python"
          if #vim.split(venv_name, "\n") == 1 then
            if vim.split(venv_name, " ")[1] == ".venv" then
              python_path = ".venv/bin/python"
            else
              python_path = string.format("%s/%s/bin/python", venv_path, venv_name)
            end
          end
          lspconfig.pyright.setup({
            settings = {
              python = {
                pythonPath = python_path,
              },
            },
          })
        end,
        ["yamlls"] = function()
          lspconfig.yamlls.setup({
            capabilities = cmp_capabilities,
            settings = {
              yaml = {
                schemas = {
                  ["https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json"] = "*.cfn.yaml",
                },
                customTags = {
                  "!And",
                  "!Base64",
                  "!Cidr",
                  "!Equals",
                  "!FindInMap sequence",
                  "!GetAZs",
                  "!GetAtt",
                  "!If",
                  "!ImportValue",
                  "!Join sequence",
                  "!Not",
                  "!Or",
                  "!Ref Scalar",
                  "!Ref",
                  "!Select",
                  "!Split",
                  "!Sub",
                  "!fn",
                },
              },
            },
          })
        end
      })
      Map("n", "gf", vim.lsp.buf.format)
      vim.api.nvim_exec_autocmds("FileType", {})
    end,
  },

  {
    "RubixDev/mason-update-all",
    dependencies = "mason.nvim",
    cmd = "MasonUpdateAll",
    config = true,
  },

  {
    "williamboman/mason.nvim",
    lazy = true,
    config = true,
  },

  {
    "glepnir/lspsaga.nvim",
    keys = {
      { "g]", "<cmd>Lspsaga diagnostic_jump_next<cr>" },
      { "g[", "<cmd>Lspsaga diagnostic_jump_prev<cr>" },
      { "gd", "<cmd>Lspsaga peek_definition<cr>" },
      { "gq", "<cmd>Lspsaga code_action<cr>" },
      { "K", "<cmd>Lspsaga hover_doc<cr>" },
    },
    config = function()
      require("lspsaga").setup({
        symbol_in_winbar = {
          enable = false,
        },
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      {
        "uga-rosa/cmp-dictionary",
        opts =
        {
          dic = {
            ["*"] = { "/usr/share/dict/words" },
          },
        },
      },
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = {
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "path" },
          { name = "buffer" },
          { name = "dictionary" },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<c-n>"] = cmp.mapping.select_next_item(),
          ["<c-p>"] = cmp.mapping.select_prev_item(),
        }),
        preselect = cmp.PreselectMode.None,
      })
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end,
  },
}
