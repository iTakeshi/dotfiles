local tab_states = {}

-- タブを閉じたら、無効になった tabpage ハンドルのエントリを掃除する。
-- （TabClosed の <afile> はタブ番号でハンドルへ変換できないため、
--  生き残っているハンドルだけを残す方式で漏れなく回収する。）
vim.api.nvim_create_autocmd("TabClosed", {
  callback = function()
    for tab_id in pairs(tab_states) do
      if not vim.api.nvim_tabpage_is_valid(tab_id) then
        tab_states[tab_id] = nil
      end
    end
  end,
})

return {
  {
    "mikavilpas/yazi.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<c-f>",
        function()
          local tab_id = vim.api.nvim_get_current_tabpage()
          local last_dir = tab_states[tab_id]
          -- 保存した「最後にいたディレクトリ」が今も存在すればそこで開く。
          -- 消えていれば現在ファイル基準（デフォルト）にフォールバック。
          if last_dir and vim.fn.isdirectory(last_dir) == 1 then
            require("yazi").yazi({}, last_dir)
          else
            require("yazi").yazi()
          end
        end,
        desc = "Open yazi at current file",
      },
    },
    opts = {
      open_for_directories = true,
      highlight_hovered_buffers_in_same_directory = false,
      keymaps = false,
      set_keymappings_function = function(buf, config, context)
        vim.keymap.set("t", "E", function()
          require("yazi.keybinding_helpers").open_file_in_vertical_split(config, context.api)
        end, { buffer = buf })
      end,
      hooks = {
        yazi_opened = function(_, buf, _)
          local opts = { buffer = buf }
          vim.keymap.set("t", "<Esc><Esc>", "<cmd>close<cr>", opts)
          vim.keymap.set("t", "<c-f>", "<cmd>close<cr>", opts)
          vim.keymap.set("t", "<Esc>", [[<c-\><c-n>]], opts)
          vim.keymap.set("t", "<c-z>", [[<c-\><c-n><cmd>suspend<cr>]], opts)

          -- yazi 内（terminal モード）からの nvim タブ操作。
          -- `<cmd>` マッピングは terminal モードを抜けずにコマンドを実行するため、
          -- yazi は元のタブに開いたまま（float はそのタブ固有）別タブへ移動できる。
          -- lhs は normal モードの `<plug>(my-tab)` 系（lua/keymaps.lua）と揃える。
          local tab_cmds = {
            n = "tabnew", l = "tabnext", h = "tabprevious", L = "-tabmove", H = "+tabmove",
            ["0"] = "tabfirst", ["$"] = "tablast",
          }
          for key, cmd in pairs(tab_cmds) do
            vim.keymap.set("t", "<leader>t" .. key, "<cmd>" .. cmd .. "<cr>", opts)
          end
          for i = 1, 9 do
            vim.keymap.set("t", "<leader>t" .. i, ("<cmd>tabnext%d<cr>"):format(i), opts)
          end

          -- タブ移動から戻ったとき yazi を再び操作できるよう terminal-insert に復帰する。
          vim.api.nvim_create_autocmd("BufEnter", {
            buffer = buf,
            callback = function()
              if vim.api.nvim_get_current_buf() == buf then
                vim.cmd("startinsert")
              end
            end,
          })

          local resume_id = vim.api.nvim_create_autocmd("VimResume", {
            callback = function()
              if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_get_current_buf() == buf then
                vim.cmd("startinsert")
              end
            end,
          })
          vim.api.nvim_create_autocmd("BufDelete", {
            buffer = buf,
            once = true,
            callback = function() vim.api.nvim_del_autocmd(resume_id) end,
          })
        end,
        -- yazi が最後にいたディレクトリをタブごとに記憶する。
        -- 第3引数 state.last_directory は yazi の cwd（--cwd-file / ya cwd 由来）で
        -- 信頼できる。previous_state.last_hovered は上流 issue #1314 のため不安定で、
        -- 取得失敗時に初期パスへフォールバックして誤った値（/tmp 等）が固着するため使わない。
        yazi_closed_successfully = function(_chosen_file, _config, state)
          local tab_id = vim.api.nvim_get_current_tabpage()
          if state and state.last_directory then
            tab_states[tab_id] = state.last_directory.filename
          end
        end,
      },
    },
  },
}
