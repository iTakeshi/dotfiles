return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- main ブランチ: nvim 0.12 対応の書き直し版。master は 0.12 非対応。
    -- モジュール(highlight/indent)は廃止され、パーサ導入は install()、
    -- ハイライトは FileType で vim.treesitter.start() を呼ぶ方式。
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup()

      -- 起動時に確実に入れておくパーサ。install() は導入済みなら no-op。
      ts.install({
        "bash",
        "css",
        "dockerfile",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "sql",
        "terraform",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      })

      -- 旧 master の auto_install=true 相当。get_available() は重いので一度だけ取得。
      local available
      local function can_install(lang)
        available = available or ts.get_available()
        return vim.tbl_contains(available, lang)
      end

      -- ハイライト有効化: パーサがあれば即 start、無ければ自動導入してから start。
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local buf = ev.buf
          local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
          if not lang then
            return
          end
          -- language.add は失敗時に throw せず nil を返すので戻り値も見る。
          local ok, added = pcall(vim.treesitter.language.add, lang)
          if ok and added then
            vim.treesitter.start(buf, lang)
          elseif can_install(lang) then
            ts.install(lang):await(function()
              if vim.api.nvim_buf_is_valid(buf) then
                vim.schedule(function()
                  vim.treesitter.start(buf, lang)
                end)
              end
            end)
          end
        end,
      })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    dependencies = "nvim-treesitter",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
      },
      scope = {
        char = "│",
      },
    },
  },
}
