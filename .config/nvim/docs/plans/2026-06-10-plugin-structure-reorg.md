# プラグイン構造 役割ベース再編 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `lua/plugins/` を役割ベースの単一責務ファイルへ再編し、設定を opts 優先・キーマップを `keys=` 集約へ統一、未使用プラグイン（rustaceanvim / crates.nvim / substitute.nvim）と未使用ヘルパ（Dump / MergeTables）を削除する。

**Architecture:** カテゴリ別ファイルを役割ベースに整理し直す。`editor.lua`/`operators.lua` を廃止し、中身を `git.lua`・`editing.lua`・`ui.lua` へ分配、配色を `colorscheme.lua` に分離。Rust は rustaceanvim を捨ててネイティブ `lsp/rust_analyzer.lua` に一本化。確定設計は `docs/specs/plugins.md`、設計記録は `docs/plans/2026-06-07-plugin-structure-reorg-design.md`。

**Tech Stack:** Neovim 0.12.2, lua, lazy.nvim, mason / mason-lspconfig v2, blink.cmp。chezmoi 管理（source: `~/.local/share/chezmoi/`）。

---

## テスト戦略についての注記

このリポジトリにはユニットテストフレームワークがない。各タスクの「検証ステップ」は手動で行う:

- ロード確認: `nvim --headless "+lua print('ok')" +qa` がエラーなく終了すること
- LSP 起動確認: 対象ファイルを開いて `:lua =vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients())`
- キーマップ確認: 対象バッファで `:nmap <key>` が期待どおり定義/未定義であること

各タスク完了後に変更ファイルを `chezmoi add`（削除は `rm` + `chezmoi forget`）して chezmoi 追跡へ反映する。このリポジトリ自体は git 管理外のため git commit は行わない。

---

## ファイル構成

- 新規作成:
  - `lua/plugins/colorscheme.lua` — sonokai
  - `lua/plugins/editing.lua` — mini.align/comment/surround, yanky, trim, vim-textobj-*
  - `lsp/rust_analyzer.lua` — rust_analyzer の settings（rustaceanvim から移植）
- 編集:
  - `lua/util.lua` — Dump / MergeTables 削除
  - `lua/plugins/ui.lua` — sonokai 除去、inspecthi 追加、noice を opts 化＋event 付与
  - `lua/plugins/git.lua` — gitsigns 追加（blame トグルを keys= へ）
  - `lua/plugins/lsp.lua` — rustaceanvim / crates.nvim 削除、automatic_enable.exclude 削除
  - `lua/plugins/statusline.lua` — tabby に `lazy = false` を明示
- 削除:
  - `lua/plugins/editor.lua`（gitsigns → git.lua、trim/textobj → editing.lua）
  - `lua/plugins/operators.lua`（mini.*/yanky → editing.lua、inspecthi → ui.lua、substitute は廃止）

---

## Task 1: util.lua から未使用ヘルパを削除

**Files:**
- Modify: `lua/util.lua`

- [ ] **Step 1: `util.lua` を Map のみに置換**

ファイル全体を以下に置き換える（`Dump` と `MergeTables` を削除、`Map` は維持）:

```lua
function Map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end
```

- [ ] **Step 2: 未使用だったことを確認**

Run: `grep -rn "Dump\|MergeTables" ~/.config/nvim/lua ~/.config/nvim/lsp ~/.config/nvim/init.lua`
Expected: ヒットなし（出力が空）。

- [ ] **Step 3: ロードを検証**

Run: `nvim --headless "+lua print('ok')" +qa`
Expected: 標準出力に `ok`、Lua エラーなし。

- [ ] **Step 4: chezmoi に反映**

```bash
chezmoi add ~/.config/nvim/lua/util.lua
```

---

## Task 2: lsp.lua から rustaceanvim / crates.nvim を削除し rust をネイティブ化

**Files:**
- Modify: `lua/plugins/lsp.lua`
- Create: `lsp/rust_analyzer.lua`

- [ ] **Step 1: `lsp/rust_analyzer.lua` を作成**

rustaceanvim の `default_settings.["rust-analyzer"]` をネイティブ設定の return table に移植する:

```lua
return {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        buildScripts = { enable = true },
      },
      checkOnSave = {
        allFeatures = true,
        command = "clippy",
        extraArgs = { "--no-deps" },
      },
      procMacro = {
        enable = true,
        ignored = {
          ["async-trait"]     = { "async_trait" },
          ["napi-derive"]     = { "napi" },
          ["async-recursion"] = { "async_recursion" },
        },
      },
    },
  },
}
```

- [ ] **Step 2: 構文を検証**

Run: `nvim --headless "+lua local c = dofile(vim.fn.expand('~/.config/nvim/lsp/rust_analyzer.lua')); assert(c.settings['rust-analyzer'].checkOnSave.command == 'clippy'); print('rust_analyzer ok')" +qa`
Expected: 標準出力に `rust_analyzer ok`、エラーなし。

- [ ] **Step 3: `lsp.lua` の mason-lspconfig から `automatic_enable` を削除**

`lua/plugins/lsp.lua` の mason-lspconfig spec の `opts` を以下へ変更する（`automatic_enable = { exclude = { "rust_analyzer" } }` ブロックを削除。`automatic_enable` は既定 true なので rust_analyzer も他言語同様に有効化される）:

変更後の mason-lspconfig spec:
```lua
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
```

- [ ] **Step 4: `lsp.lua` から rustaceanvim spec を削除**

`-- Enhanced Rust support` コメント行から `mrcjkb/rustaceanvim` の spec 全体（対応する閉じ `},` まで）を削除する。

- [ ] **Step 5: `lsp.lua` から crates.nvim spec を削除**

`-- Rust crates.io integration` コメント行から `saecki/crates.nvim` の spec 全体（対応する閉じ `},` まで）を削除する。

削除後、`lsp.lua` の spec は mason / mason-lspconfig / blink.cmp / nvim-lspconfig / mason-update-all / fidget の6つになる。

- [ ] **Step 6: ロードを検証**

Run: `nvim --headless "+lua print('ok')" +qa`
Expected: 標準出力に `ok`、Lua エラーなし。

- [ ] **Step 7: 未使用プラグインを clean**

Run: `nvim --headless "+Lazy! sync" +qa`
Expected: rustaceanvim / crates.nvim がアンインストールされエラーなく終了。

- [ ] **Step 8: rust のネイティブ attach を検証**

任意の Rust プロジェクトの `.rs` ファイルを `nvim` で開き、以下を実行:
- `:lua =vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients())` → `rust_analyzer` が含まれる。
- `:lua =vim.lsp.get_clients({ name = 'rust_analyzer' })[1].settings['rust-analyzer'].checkOnSave.command` → `clippy`。
- `:RustLsp` → コマンドが存在しない（E492 等）。rustaceanvim が消えたことの確認。

- [ ] **Step 9: chezmoi に反映**

```bash
chezmoi add ~/.config/nvim/lsp/rust_analyzer.lua
chezmoi add ~/.config/nvim/lua/plugins/lsp.lua
chezmoi add ~/.config/nvim/lazy-lock.json
```

---

## Task 3: ファイル再編（editor.lua / operators.lua → colorscheme / ui / git / editing）

このタスクは複数ファイルを跨いでプラグインを移動する。**重複 spec（同一プラグインが2ファイルに存在）の中間状態を作らない**ため、新ファイル作成・既存編集・旧ファイル削除をすべて行ってからロード検証する。

**Files:**
- Create: `lua/plugins/colorscheme.lua`, `lua/plugins/editing.lua`
- Modify: `lua/plugins/ui.lua`, `lua/plugins/git.lua`
- Delete: `lua/plugins/editor.lua`, `lua/plugins/operators.lua`

- [ ] **Step 1: `lua/plugins/colorscheme.lua` を作成**

sonokai を ui.lua から分離。`colorscheme` コマンドは副作用のため `config` を維持する:

```lua
return {
  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("sonokai")
    end,
  },
}
```

- [ ] **Step 2: `lua/plugins/ui.lua` を書き換え**

sonokai を除去し、inspecthi（operators.lua から移動）を追加。noice は `config = true` を `opts = {}` に、`event = "VeryLazy"` を付与:

```lua
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
```

- [ ] **Step 3: `lua/plugins/git.lua` を書き換え**

gitsigns（editor.lua から移動）を追加。blame トグルを `on_attach` 内の `Map()` から `keys=` へ移設。signs 表示のため `event` でファイルロード時に読み込み。diffview / lazygit は現状維持（lazygit の TermOpen autocmd は副作用のため config を維持）:

```lua
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
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
```

- [ ] **Step 4: `lua/plugins/editing.lua` を作成**

operators.lua の mini.*/yanky と editor.lua の trim/textobj を統合。substitute は含めない。mini.* は `opts.mappings` でキー登録し、lazy-load 用に `keys=` へトリガーキーを併記。trim は `config` 関数を `opts` 化しトグルを `keys=` へ。yanky は yank 履歴を取りこぼさないため `event = "VeryLazy"` を維持しつつ put マッピングを `keys=` に集約:

```lua
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
```

- [ ] **Step 5: 旧ファイルを削除し chezmoi source からも除去**

```bash
rm ~/.config/nvim/lua/plugins/editor.lua ~/.config/nvim/lua/plugins/operators.lua
chezmoi forget --force ~/.config/nvim/lua/plugins/editor.lua
chezmoi forget --force ~/.config/nvim/lua/plugins/operators.lua
```

- [ ] **Step 6: ロードを検証（重複 spec が無いこと）**

Run: `nvim --headless "+lua print('ok')" +qa`
Expected: 標準出力に `ok`、Lua エラーなし（重複プラグイン spec のエラーが出ないこと）。

- [ ] **Step 7: 未使用プラグインを clean**

Run: `nvim --headless "+Lazy! sync" +qa`
Expected: substitute.nvim がアンインストールされエラーなく終了。

- [ ] **Step 8: キーマップ/挙動を検証**

`nvim` で適当なファイルを開き、以下を確認:
- `Tb` → git blame の virtual text がトグルする（gitsigns ロード）。
- `TW` → trim on save がトグルする。
- `gsaiw"` 等で surround が追加できる。
- `ga` で mini.align が起動する。
- `yiw` 後に `p` で yanky put が動く。
- `:Inspecthi` がカーソル下のハイライトを表示する。

- [ ] **Step 9: chezmoi に反映**

```bash
chezmoi add ~/.config/nvim/lua/plugins/colorscheme.lua
chezmoi add ~/.config/nvim/lua/plugins/ui.lua
chezmoi add ~/.config/nvim/lua/plugins/git.lua
chezmoi add ~/.config/nvim/lua/plugins/editing.lua
chezmoi add ~/.config/nvim/lazy-lock.json
```

---

## Task 4: statusline.lua の tabby に lazy=false を明示

**Files:**
- Modify: `lua/plugins/statusline.lua`

tabby はタブラインを起動時に描画する必要があり起動時ロードが正しい。トリガー無しの暗黙ロードを明示的な `lazy = false` に変える（lualine は現状維持）。

- [ ] **Step 1: tabby spec に `lazy = false` を追加**

`nanozuki/tabby.nvim` の spec に `lazy = false,` を1行追加する（`config = function()` の直前）:

```lua
  {
    "nanozuki/tabby.nvim",
    lazy = false,
    config = function()
```

- [ ] **Step 2: ロードとタブライン表示を検証**

Run: `nvim --headless "+lua print('ok')" +qa`
Expected: 標準出力に `ok`、エラーなし。

`nvim` を起動し、上部のタブラインが従来どおり表示されることを目視確認。

- [ ] **Step 3: chezmoi に反映**

```bash
chezmoi add ~/.config/nvim/lua/plugins/statusline.lua
```

---

## Task 5: 全体統合検証と spec の状態更新

**Files:**
- Modify: `docs/specs/plugins.md`（「設計済み・未実装」注記を外す）

- [ ] **Step 1: クリーン起動で health にエラーがないこと**

Run: `nvim --headless "+checkhealth lazy" "+w! /tmp/lazy-health.txt" +qa` 実行後、`grep -i error /tmp/lazy-health.txt`
Expected: ERROR の該当なし。

- [ ] **Step 2: 各 ft で LSP attach を確認**

それぞれ開いて `:lua =vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients())`:
- `.lua` → `lua_ls`
- `.py` → `pyright`（および `ruff`）
- `.rs` → `rust_analyzer`（ネイティブ）
- `.ts` → `ts_ls`
- `.yaml` → `yamlls`

- [ ] **Step 3: 不要プラグインが残っていないこと**

Run: `grep -rn "rustaceanvim\|crates.nvim\|substitute" ~/.config/nvim/lua ~/.config/nvim/lazy-lock.json`
Expected: ヒットなし（lazy-lock.json からも消えている）。

- [ ] **Step 4: spec の状態注記を更新**

`docs/specs/plugins.md` 冒頭の状態ブロックから「設計済み・未実装」注記を外し、`**最終更新: 2026-06-10**` に更新する。

変更前:
```markdown
**最終更新: 2026-06-07**

> **状態: 設計済み・未実装。** 役割ベース再編の確定設計。実装が完了したらこの注記を外す。
> 設計記録は ...
```
変更後:
```markdown
**最終更新: 2026-06-10**

> 設計記録は ...
```

- [ ] **Step 5: 最終 chezmoi 確認**

Run: `chezmoi status`
Expected: nvim 配下の変更が全て chezmoi に取り込まれており、未追跡の差分がない。残差分があれば該当ファイルを `chezmoi add` する。

```bash
chezmoi add ~/.config/nvim/docs/specs/plugins.md
```

---

## Self-Review メモ

- **Spec coverage:** ① 棚卸し = Task 1（ヘルパ）/Task 2（rust 系）/Task 3 Step5,7（substitute・旧ファイル）。② ファイル再編 = Task 3。③ opts 優先＋lazy 正確化 = Task 2,3,4（noice/trim/yanky/gitsigns/tabby）。④ keys= 集約 = Task 3（gitsigns blame・trim toggle・yanky put・mini.*）。treesitter は据え置きで対象外（spec 明記どおり）。全 spec 項目にタスク対応あり。
- **Placeholder scan:** 全ステップに実コード/実コマンドを記載。プレースホルダなし。
- **Type consistency:** `lsp/rust_analyzer.lua` の `settings["rust-analyzer"]` キーは Task 2 Step1 と Step8 の検証で一致。`<plug>(my-toggle)b`/`W` は keymaps.lua のプレフィックス定義（既存）に依存。mini.* の opts.mappings と keys= のトリガーキーは各 spec 内で一致。
