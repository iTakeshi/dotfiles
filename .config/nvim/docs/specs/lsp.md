# LSP 設定 (design-of-record)

**最終更新: 2026-06-07**

Neovim 0.12 時代のネイティブ LSP API を前提とした LSP 設定の確定設計。すべて実装済み。

関連: 設計記録は [`plans/2026-06-06-lsp-nvim012-modernization-design.md`](../plans/2026-06-06-lsp-nvim012-modernization-design.md)、実装計画は [`plans/2026-06-07-lsp-nvim012-modernization.md`](../plans/2026-06-07-lsp-nvim012-modernization.md)。

## 全体方針

- ネイティブ LSP（`vim.lsp.config` / `vim.lsp.enable` / `vim.diagnostic` / 0.11 デフォルトキーマップ）を主軸とし、重量級 plugin（LspSaga 等）は使わないミニマル構成。
- サーバー設定は **`lsp/<name>.lua`** に分割し、nvim-lspconfig 同梱のデフォルト（`cmd`/`filetypes`/`root_markers`）と自動マージする。
- `lua/plugins/lsp.lua` はサーバー非依存部分（plugin spec・診断設定・LspAttach キーマップ）のみを持つ。

## サーバー管理

- **mason.nvim** + **mason-lspconfig.nvim (v2)** で管理。
- `ensure_installed`: biome, lua_ls, pyright, ruff, rust_analyzer, terraformls, tflint, tinymist, ts_ls, vacuum, yamlls。
- **`automatic_enable`** が installed サーバーを `vim.lsp.enable()` で有効化し、`lsp/*.lua` を自動的に拾う。`rust_analyzer` は exclude（rustaceanvim が担当）。

## サーバー個別設定（`lsp/*.lua`）

各ファイルは設定 table を `return` する。

| ファイル | 内容 |
|--------|------|
| `lsp/lua_ls.lua` | LuaJIT runtime、VIMRUNTIME library、`callSnippet=Replace`、inlay hint |
| `lsp/pyright.lua` | venv 検出（`.venv` / `$VIRTUAL_ENV`）による pythonPath、`typeCheckingMode=basic` |
| `lsp/yamlls.lua` | CloudFormation / GitHub Actions の schema、CFn customTags |
| `lsp/ts_ls.lua` | TypeScript/JavaScript の inlayHints 一式 |

Lua 開発支援は **lazydev.nvim**（`vim.uv` 等のライブラリ補完）を併用。

## 補完

- **blink.cmp** (v1.x)。sources は lsp / path / snippets / buffer、score_offset で lsp 優先。
- capabilities は blink.cmp が `vim.lsp.config('*')` 経由で全サーバーへ自動付与（個別設定不要）。
- signature help 有効、documentation auto_show 有効。

## キーマップ

0.11 のデフォルトグローバルキーマップを活用し、重複する自前マップは持たない。

**デフォルト（自動）**: `grn`(rename) / `gra`(code action) / `grr`(references) / `gri`(implementation) / `grt`(type definition) / `gO`(document symbol) / `K`(hover) / `<C-s>`(signature, insert) / `[d`・`]d`(診断移動)。

**自前（`LspAttach` で buffer-local に追加）**:
| キー | 動作 |
|----|------|
| `gd` | definition（デフォルトに無いため自前） |
| `gf` | format（標準 `gf`=goto file を上書き。意図的） |
| `g[` / `g]` | 診断ジャンプ（float 付き。標準 `[d`/`]d` と併存） |
| `<leader>ih` | inlay hint トグル |

## 診断・UI

- `vim.diagnostic.config`: virtual_text（prefix `●`）、severity 別 sign、underline、severity_sort、float（border rounded・`source=true`）。
- `vim.o.winborder = "rounded"`（`lua/base.lua`）でフロートウィンドウのボーダーをグローバル指定。LSP 遅延ロードに依存させない。

## 言語固有の拡張

- **rustaceanvim** (`^5`): rust_analyzer を rustaceanvim 経由で起動（mason-lspconfig からは exclude）。allFeatures、checkOnSave=clippy、procMacro、inlay hint 自動有効化。
- **crates.nvim**: `Cargo.toml` の crates.io 連携（補完・hover・code action）。

## 進捗表示

- **fidget.nvim**（`event = "LspAttach"`）で LSP 進捗を表示。
