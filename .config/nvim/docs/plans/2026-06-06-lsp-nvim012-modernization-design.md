# LSP設定の nvim 0.12 時代向けモダナイゼーション 設計書

- 日付: 2026-06-06
- 対象: `~/.config/nvim`（Neovim 0.12.2）
- スコープ: (A) `lsp/` ディレクトリ方式への移行、(B) 0.11 デフォルトキーマップ採用、(C) plugin 構成の見直し

## 背景と現状評価

現状の `lua/plugins/lsp.lua` はすでにモダンで、`vim.lsp.config()`・`LspAttach`・mason-lspconfig v2 の `automatic_enable` を使用している。ただし 0.12 時代の理想形に対して以下の差分がある:

1. サーバー設定が一枚の巨大な `config = function()` に集中している
2. 0.11 のデフォルト LSP キーマップ（`grn`/`gra`/`grr` 等）を活用できておらず、**rename と references のマッピングが存在しない**
3. `vim.diagnostic.config` の `float.source = "always"` が非推奨方向

補完は blink.cmp、診断・hover はネイティブ任せのミニマル構成。LspSaga 等の重量級 plugin は導入されていない（確認済み）。この方向性自体は 0.12 時代として正しい。

## 確定した判断

- **format キー**: 現状の `gf` = `vim.lsp.buf.format` を維持（標準 `gf` = goto file は潰すが現状維持を優先）
- **追加 plugin**: fidget.nvim のみ（trouble.nvim / conform.nvim は今回見送り）

## Part A — `lsp/` ディレクトリ方式への移行

### 構成

サーバーごとの設定を runtime の `lsp/<name>.lua` に切り出し、設定 table を return する。Neovim が nvim-lspconfig 同梱の `lsp/<name>.lua`（`cmd`/`filetypes`/`root_markers`）と自動マージする。

```
~/.config/nvim/
  lsp/
    lua_ls.lua    -- return { settings = { Lua = {...} } }
    pyright.lua   -- venv 検出ロジックごと移動。return { settings = { python = {...} } }
    yamlls.lua    -- schemas / customTags
    ts_ls.lua     -- typescript/javascript inlayHints
```

各ファイルは現在 `lsp.lua` 内の `vim.lsp.config(name, {...})` の第2引数をそのまま return する。

### 有効化方式

`mason-lspconfig` の `automatic_enable`（rust_analyzer を exclude）を**維持**する。これが installed なサーバーに対し内部で `vim.lsp.enable()` を呼び、`lsp/` ファイルが自動的に拾われる。`ensure_installed` リストは現状維持。

→ 結果として **`lsp.lua` 内の 4つの `vim.lsp.config(...)` 呼び出しを丸ごと削除**できる。

### `lsp.lua` に残すサーバー非依存部分

`nvim-lspconfig` spec の `config = function()` を以下のみに縮小する:

- `vim.diagnostic.config(...)` — `float.source = "always"` → `source = true` に修正。それ以外は現状維持
- `LspAttach` のキーマップ（Part B 参照）
- 新規: `vim.o.winborder = "rounded"`（0.11+。hover/signature/補完ドキュメント等の border をグローバル指定）

`capabilities` は blink.cmp 1.x が `vim.lsp.config('*')` 経由で自動付与するため追加対応不要。

## Part B — 0.11 デフォルトキーマップ採用

Neovim 0.11+ は LspAttach 時に以下を自動で張る（setup 不要）:
`grn`(rename) / `gra`(code action) / `grr`(references) / `gri`(implementation) / `grt`(type definition) / `gO`(document symbol) / `K`(hover) / `<C-s>`(signature, insert) / `[d`・`]d`(診断移動)。

これにより **rename と references を新たに獲得**する。

### LspAttach キーマップの整理

| 現状マップ | 対応 | 理由 |
|---|---|---|
| `gx` = code_action | **削除** | 標準 `gra` を使用。`gx` 本来の URL オープンも復活 |
| `K` = hover | **削除** | 標準 `K`(hover) で十分。buffer-local 標準が機能する |
| `gd` = definition | **維持** | 標準には `gd` がないため |
| `gf` = format | **維持** | 確定判断による |
| `g[` / `g]` = 診断ジャンプ(float付き) | **維持** | 標準 `[d`/`]d` と併存。float 付きで便利 |
| `<leader>ih` = inlay hint toggle | **維持** | |

### keymaps.lua の既存干渉箇所（今回は現状維持・注記のみ）

- L46 `K`=`<nop>`（グローバル）: buffer-local の標準 K が勝つため LSP 機能に実害なし。今回は触らない。
- L91-92 `<c-w>d` / `<c-w><c-d>` の `del`: これは 0.11 標準の診断 float 表示マップ。`g[`/`g]` で float を出せるため削除したまま維持する（今回は復活させない）。

## Part C — plugin 構成

### 結論

- **LspSaga は導入しない**: rename/code action/hover が全てネイティブ化した現在、重量に見合わず旧式。現状のネイティブ + blink.cmp のミニマル構成を維持する方針が 0.12 時代として正しい。
- **fidget.nvim を追加**: LSP 進捗を表示する軽量 plugin。

### fidget.nvim の plugin spec（`lsp.lua` に追加）

```lua
{
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {},
},
```

### 見送り（今回スコープ外）

- trouble.nvim（診断/references 一覧UI）
- conform.nvim（filetype 別フォーマッタルーティング）

## 変更対象ファイル一覧

- 新規: `lsp/lua_ls.lua`, `lsp/pyright.lua`, `lsp/yamlls.lua`, `lsp/ts_ls.lua`
- 編集: `lua/plugins/lsp.lua`
  - 4つの `vim.lsp.config(...)` 呼び出しを削除
  - `diagnostic.config` の `source = true` 修正
  - `vim.o.winborder = "rounded"` 追加
  - `LspAttach` から `gx` / `K` を削除
  - fidget.nvim spec 追加

## 影響範囲・リスク

- mason-lspconfig の `automatic_enable` が `lsp/` ファイルを正しく拾うことが前提。拾わない場合のフォールバックとして明示的 `vim.lsp.enable({...})` を検討。
- `vim.o.winborder` はグローバル設定のため、各 plugin(mason/lazy/rustaceanvim) の個別 border 指定との二重化が起きるが、個別指定が優先されるため動作上の害はない（DRY 化は任意の後続作業）。
- キーマップ変更により `gx`/`K` の手癖が変わる（`gx`→`gra` で code action）。

## 成功基準

- 各 LSP が `lsp/` ファイル経由で従来同等の設定で起動する
- `grn`(rename) と `grr`(references) が LSP バッファで機能する
- `lsp.lua` から per-server `vim.lsp.config` が消え、config 関数がサーバー非依存部分のみになる
- fidget.nvim が LSP 起動時に進捗を表示する
- 診断・hover・inlay hint が従来通り動作する

## 補足

このリポジトリは git 管理ではなく chezmoi 管理（source: `~/.local/share/chezmoi/`）。本設計書のコミットは行わず、適用後に `chezmoi add` で追跡対象に含める想定。
