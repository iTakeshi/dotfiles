# LSP設定 nvim 0.12 時代向けモダナイゼーション Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 既存の Neovim LSP 設定を nvim 0.12 時代の慣用形（`lsp/*.lua` 分割 + ネイティブデフォルトキーマップ）へ移行し、fidget.nvim を追加する。

**Architecture:** 各サーバー設定を `~/.config/nvim/lsp/<name>.lua` に切り出して return table 化し、nvim-lspconfig 同梱デフォルトと自動マージ。mason-lspconfig の `automatic_enable` がそれらを `vim.lsp.enable()` する。`lua/plugins/lsp.lua` はサーバー非依存部分（診断設定・LspAttachキーマップ・winborder・plugin spec）のみに縮小する。

**Tech Stack:** Neovim 0.12.2, lua, lazy.nvim, mason / mason-lspconfig v2, blink.cmp, fidget.nvim

---

## テスト戦略についての注記

このリポジトリにはユニットテストフレームワークがない。各タスクの「検証ステップ」は以下の手動コマンドで行う:

- ロード確認: `nvim --headless "+lua print('ok')" +qa` がエラーなく終了すること
- 設定構文確認: `nvim --headless "+luafile <file>" +qa`（return table のファイルは後述の専用コマンド）
- LSP 起動確認: 対象ファイルを開いて `:checkhealth vim.lsp` または `:lua =vim.lsp.get_clients()` でクライアントが attach していること
- キーマップ確認: 対象バッファで `:nmap grn` 等が定義済みであること

各タスクは完了後に `chezmoi add <file>` で chezmoi 追跡へ反映し、git ではなく chezmoi 管理である点に注意（このリポジトリ自体は git 管理外）。コミットステップは chezmoi の source ディレクトリに対して行う想定だが、source 側のコミット運用が未確立の場合は `chezmoi add` のみ実施する。

---

## ファイル構成

- 新規作成:
  - `lsp/lua_ls.lua` — lua_ls の settings を return
  - `lsp/pyright.lua` — pyright の settings（venv検出ロジック含む）を return
  - `lsp/yamlls.lua` — yamlls の settings（schemas/customTags）を return
  - `lsp/ts_ls.lua` — ts_ls の settings（inlayHints）を return
- 編集:
  - `lua/plugins/lsp.lua` — `vim.lsp.config(...)` 4箇所削除、診断設定の `source=true` 修正、`winborder` 追加、LspAttach から `gx`/`K` 削除、fidget.nvim spec 追加

---

## Task 1: lua_ls 設定を `lsp/lua_ls.lua` に切り出す

**Files:**
- Create: `lsp/lua_ls.lua`
- Reference: `lua/plugins/lsp.lua:95-108`（移行元、この時点ではまだ削除しない）

- [ ] **Step 1: `lsp/lua_ls.lua` を作成**

`lua/plugins/lsp.lua:95-108` の `vim.lsp.config("lua_ls", {...})` の第2引数をそのまま return する。

```lua
return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
      completion = { callSnippet = "Replace" },
      telemetry = { enable = false },
      hint = { enable = true },
    },
  },
}
```

- [ ] **Step 2: 構文を検証**

Run: `nvim --headless "+lua local c = dofile('lsp/lua_ls.lua'); assert(c.settings.Lua.runtime.version == 'LuaJIT'); print('lua_ls ok')" +qa`
Expected: 標準出力に `lua_ls ok`、エラーなし

- [ ] **Step 3: chezmoi に追跡させる**

```bash
chezmoi add ~/.config/nvim/lsp/lua_ls.lua
```

---

## Task 2: pyright 設定を `lsp/pyright.lua` に切り出す

**Files:**
- Create: `lsp/pyright.lua`
- Reference: `lua/plugins/lsp.lua:111-131`

- [ ] **Step 1: `lsp/pyright.lua` を作成**

venv 検出の即時実行関数（IIFE）込みでそのまま移す。

```lua
return {
  settings = {
    python = {
      pythonPath = (function()
        local python_path = "python"
        if vim.fn.filereadable(".venv/bin/activate") == 1 then
          python_path = ".venv/bin/python"
        end
        local virtual_env = os.getenv("VIRTUAL_ENV")
        if virtual_env then
          python_path = string.format("%s/bin/python", virtual_env)
        end
        return python_path
      end)(),
      analysis = {
        typeCheckingMode = "basic",
        autoImportCompletions = true,
      },
    },
  },
}
```

> 注: `pythonPath` の IIFE はこのファイルが `dofile`/読み込みされた時点で1回評価される。`lsp/` ファイルは LSP 起動時に読まれるため、起動時のカレントディレクトリ・環境変数が反映される。挙動は移行前（config 関数実行時に1回評価）から実質変わらない。

- [ ] **Step 2: 構文を検証**

Run: `nvim --headless "+lua local c = dofile('lsp/pyright.lua'); assert(type(c.settings.python.pythonPath) == 'string'); print('pyright ok')" +qa`
Expected: 標準出力に `pyright ok`、エラーなし

- [ ] **Step 3: chezmoi に追跡させる**

```bash
chezmoi add ~/.config/nvim/lsp/pyright.lua
```

---

## Task 3: yamlls 設定を `lsp/yamlls.lua` に切り出す

**Files:**
- Create: `lsp/yamlls.lua`
- Reference: `lua/plugins/lsp.lua:134-148`

- [ ] **Step 1: `lsp/yamlls.lua` を作成**

```lua
return {
  settings = {
    yaml = {
      schemas = {
        ["https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json"] = "*.cfn.yml",
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
      customTags = {
        "!And", "!Base64", "!Cidr", "!Equals", "!FindInMap sequence",
        "!GetAZs", "!GetAtt", "!If", "!ImportValue", "!Join sequence",
        "!Not", "!Or", "!Ref Scalar", "!Ref", "!Select", "!Split", "!Sub", "!fn",
      },
    },
  },
}
```

- [ ] **Step 2: 構文を検証**

Run: `nvim --headless "+lua local c = dofile('lsp/yamlls.lua'); assert(#c.settings.yaml.customTags == 18); print('yamlls ok')" +qa`
Expected: 標準出力に `yamlls ok`、エラーなし

- [ ] **Step 3: chezmoi に追跡させる**

```bash
chezmoi add ~/.config/nvim/lsp/yamlls.lua
```

---

## Task 4: ts_ls 設定を `lsp/ts_ls.lua` に切り出す

**Files:**
- Create: `lsp/ts_ls.lua`
- Reference: `lua/plugins/lsp.lua:151-176`

- [ ] **Step 1: `lsp/ts_ls.lua` を作成**

```lua
return {
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
}
```

- [ ] **Step 2: 構文を検証**

Run: `nvim --headless "+lua local c = dofile('lsp/ts_ls.lua'); assert(c.settings.typescript.inlayHints.includeInlayParameterNameHints == 'all'); print('ts_ls ok')" +qa`
Expected: 標準出力に `ts_ls ok`、エラーなし

- [ ] **Step 3: chezmoi に追跡させる**

```bash
chezmoi add ~/.config/nvim/lsp/ts_ls.lua
```

---

## Task 5: `lsp.lua` から per-server `vim.lsp.config(...)` を削除

**Files:**
- Modify: `lua/plugins/lsp.lua`（`config = function()` 内）

このタスクで、Task 1-4 で切り出した 4つの `vim.lsp.config(...)` ブロックを削除する。`automatic_enable` が `lsp/*.lua` を拾うため、設定は失われない。

- [ ] **Step 1: `vim.lsp.config("lua_ls", {...})` ブロックを削除**

`lua/plugins/lsp.lua` の以下のブロック（コメント `-- Lua Language Server` を含む 95-108 行相当）を削除する。

削除対象（コメント行から閉じ `})` まで）:
```lua
      -- Lua Language Server
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
            completion = { callSnippet = "Replace" },
            telemetry = { enable = false },
            hint = { enable = true },
          },
        },
      })
```

- [ ] **Step 2: `vim.lsp.config("pyright", {...})` ブロックを削除**

`-- Python (Pyright)` コメント行から対応する閉じ `})` までを削除する。

- [ ] **Step 3: `vim.lsp.config("yamlls", {...})` ブロックを削除**

`-- YAML Language Server` コメント行から対応する閉じ `})` までを削除する。

- [ ] **Step 4: `vim.lsp.config("ts_ls", {...})` ブロックを削除**

`-- TypeScript/JavaScript Language Server` コメント行から対応する閉じ `})` までを削除する。

削除後、`config = function()` 内の残りは「診断設定 (`vim.diagnostic.config`)」「LspAttach autocmd」「`vim.api.nvim_exec_autocmds("FileType", {})`」のみになる。

- [ ] **Step 5: ロードを検証**

Run: `nvim --headless "+lua print('loaded')" +qa`
Expected: 標準出力に `loaded`、Lua エラーなし

- [ ] **Step 6: LSP attach を検証**

`nvim` で適当な Lua ファイル（例 `lua/base.lua`）を開き、`:lua =vim.lsp.get_clients({ name = 'lua_ls' })[1] ~= nil` を実行。
Expected: `true`（lua_ls が attach し、`lsp/lua_ls.lua` の設定でロードされている）。`:lua =vim.lsp.get_clients()[1].settings` で settings が反映されていることも確認。

- [ ] **Step 7: chezmoi に反映**

```bash
chezmoi add ~/.config/nvim/lua/plugins/lsp.lua
```

---

## Task 6: 診断設定の deprecation 修正と winborder 追加

**Files:**
- Modify: `lua/plugins/lsp.lua`（`vim.diagnostic.config` の `float` ブロック、および `config` 関数冒頭）

- [ ] **Step 1: `float.source` を `true` に修正**

`vim.diagnostic.config({...})` の `float` テーブル内、`source = "always"` を以下に変更する。

変更前:
```lua
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
```
変更後:
```lua
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
```

- [ ] **Step 2: `winborder` を追加**

`config = function()` の冒頭（`vim.lsp.config` 群があった位置、現在は `vim.diagnostic.config` の直前）に1行追加する。

```lua
      -- グローバルなフロートウィンドウのボーダー（hover/signature/補完ドキュメント等）
      vim.o.winborder = "rounded"
```

- [ ] **Step 3: 検証**

Run: `nvim --headless "+lua print(vim.o.winborder)" +qa`
Expected: 標準出力に `rounded`

そのうえで `nvim` で Lua ファイルを開き、関数上で `K`（hover）を押すとボーダー付きフロートが出ることを目視確認。

- [ ] **Step 4: chezmoi に反映**

```bash
chezmoi add ~/.config/nvim/lua/plugins/lsp.lua
```

---

## Task 7: LspAttach キーマップから `gx` と `K` を削除

**Files:**
- Modify: `lua/plugins/lsp.lua`（`LspAttach` autocmd 内、213-214 行相当）

0.11 標準の `gra`(code action) と `K`(hover) を使うため、重複する自前マップを削除する。`gd`/`gf`/`g[`/`g]`/`<leader>ih` は維持する。

- [ ] **Step 1: `gx` と `K` のマップ行を削除**

`LspAttach` callback 内の以下2行を削除する。

```lua
          Map("n", "gx",         vim.lsp.buf.code_action, opts)
          Map("n", "K",          vim.lsp.buf.hover, opts)
```

削除後の callback の Map 群:
```lua
          local opts = { buffer = ev.buf }
          Map("n", "gf",         vim.lsp.buf.format, opts)
          Map("n", "gd",         vim.lsp.buf.definition, opts)
          Map("n", "g]",         function() vim.diagnostic.jump({ count = 1,  float = true }) end, opts)
          Map("n", "g[",         function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
          Map("n", "<leader>ih", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, opts)
```

- [ ] **Step 2: 標準キーマップの存在を検証**

`nvim` で Lua ファイル（LSP attach 済み）を開き、以下を実行:
- `:nmap grn` → `vim.lsp.buf.rename` 系のマップが表示される（標準）
- `:nmap gra` → code action 系が表示される（標準）
- `:nmap grr` → references 系が表示される（標準）
- `:nmap gx` → `<Nop>` または URL オープン（自前マップが消え、code action でなくなっている）

Expected: `grn`/`gra`/`grr` が標準で存在し、`gx` が code action ではなくなっている。

- [ ] **Step 3: rename と references の動作確認**

Lua ファイルでシンボル上にカーソルを置き `grn` で rename プロンプトが出ること、`grr` で references が quickfix/location list に出ることを目視確認。

- [ ] **Step 4: chezmoi に反映**

```bash
chezmoi add ~/.config/nvim/lua/plugins/lsp.lua
```

---

## Task 8: fidget.nvim を追加

**Files:**
- Modify: `lua/plugins/lsp.lua`（plugin spec を1つ追加）

- [ ] **Step 1: fidget.nvim spec を追加**

`lua/plugins/lsp.lua` の `return { ... }` 内（他の plugin spec と並ぶ位置、例えば mason-update-all の後）に追加する。

```lua
  -- LSP 進捗表示
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },
```

- [ ] **Step 2: plugin をインストール**

Run: `nvim --headless "+Lazy! sync" +qa`
Expected: fidget.nvim が clone/install され、エラーなく終了。

- [ ] **Step 3: 動作確認**

`nvim` で大きめのプロジェクト（または Lua ファイル）を開き、LSP 起動時に画面右下に進捗表示が一瞬出ることを目視確認。

Run（ロード確認の代替）: `nvim --headless "+lua require('fidget'); print('fidget ok')" +qa`
Expected: 標準出力に `fidget ok`

- [ ] **Step 4: chezmoi に反映**

```bash
chezmoi add ~/.config/nvim/lua/plugins/lsp.lua
chezmoi add ~/.config/nvim/lazy-lock.json
```

---

## Task 9: 全体統合検証

**Files:** なし（検証のみ）

- [ ] **Step 1: クリーン起動でエラーがないこと**

Run: `nvim --headless "+checkhealth vim.lsp" "+w! /tmp/lsp-health.txt" +qa` を実行後、`/tmp/lsp-health.txt` に ERROR がないことを確認（`grep -i error /tmp/lsp-health.txt` で該当なし）。

- [ ] **Step 2: 各サーバーの attach 確認**

それぞれのファイルタイプを開き `:lua =vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients())` でクライアント名が出ることを確認:
- `.lua` → `lua_ls`
- `.py` → `pyright`（および `ruff`）
- `.yaml`/`.yml` → `yamlls`
- `.ts` → `ts_ls`

- [ ] **Step 3: 設計書の成功基準を照合**

設計書 `docs/superpowers/specs/2026-06-06-lsp-nvim012-modernization-design.md` の「成功基準」5項目を1つずつ確認:
1. 各 LSP が `lsp/` ファイル経由で起動 ✓
2. `grn`/`grr` が機能 ✓
3. `lsp.lua` から per-server `vim.lsp.config` が消えた ✓
4. fidget.nvim が進捗表示 ✓
5. 診断・hover・inlay hint が従来通り ✓

- [ ] **Step 4: 最終 chezmoi 確認**

Run: `chezmoi status`
Expected: nvim 配下の変更が全て chezmoi に取り込まれており、未追跡の差分がない。

---

## Self-Review メモ

- **Spec coverage:** Part A（lsp/移行）= Task 1-5、診断/winborder = Task 6、Part B（キーマップ）= Task 7、Part C（fidget）= Task 8、成功基準照合 = Task 9。全項目にタスク対応あり。
- **Placeholder scan:** 全ステップに実コードまたは実コマンドを記載。プレースホルダなし。
- **Type consistency:** 各 `lsp/*.lua` は `return { settings = {...} }` で統一。Task 5 の削除対象は Task 1-4 の作成内容と一致。
