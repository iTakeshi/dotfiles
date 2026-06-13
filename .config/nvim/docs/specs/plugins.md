# プラグイン構造 (design-of-record)

**最終更新: 2026-06-13**

> 設計記録は [`plans/2026-06-07-plugin-structure-reorg-design.md`](../plans/2026-06-07-plugin-structure-reorg-design.md)。LSP 個別の design-of-record は [`lsp.md`](lsp.md)。

`lua/plugins/*.lua` は lazy.nvim の `{ import = "plugins" }` で読み込む。各ファイルは spec のリストを return し、**1ファイル = 1つの役割（単一責務）**で構成する。

## 全体方針

- **役割ごとにファイル分割**（1プラグイン1ファイルは採らない）。各ファイルが単一責務を持つ。
- **opts 優先**: lazy.nvim 公式の「`config` is almost never needed」に従い、`require().setup()` を呼ぶだけの `config` 関数は `opts` テーブルにする。`config`/`init`/関数は副作用（autocmd・`<Plug>` 以外のキー・`vim.g.*`）がある時だけ使う。
- **正確な lazy トリガー**: `event = "VeryLazy"` の安易な多用やトリガー無しの起動時ロードを避け、`keys`/`cmd`/`ft` で表せるものはそれを使う。
- **キーマップは `keys=` に集約**: プラグイン固有キーは spec の `keys=` に置き、lazy-load トリガーを兼ねる。`config`/`on_attach` 内で `Map()` するのは原則避ける。素の vim 操作とグローバル予約は `keymaps.lua` に集約。

## ファイル構成

| ファイル | 役割 | プラグイン |
|--------|------|--------|
| `colorscheme.lua` | 配色 | sonokai |
| `ui.lua` | UI chrome・通知・アイコン・ハイライト確認 | noice, nvim-notify, nui, nvim-web-devicons, inspecthi |
| `statusline.lua` | ステータス/タブライン | lualine, tabby |
| `treesitter.lua` | 構文・インデント表示 | nvim-treesitter, indent-blankline |
| `editing.lua` | 編集オペレータ・テキストオブジェクト | mini.align, mini.comment, mini.surround, yanky.nvim, trim.nvim, vim-textobj-{user,line,url,parameter} |
| `git.lua` | Git 連携 | gitsigns, diffview.nvim, lazygit.nvim |
| `fuzzy.lua` | ファインダ | fzf-lua |
| `terminal.lua` | 端末 | toggleterm.nvim |
| `yazi.lua` | ファイラ | yazi.nvim |
| `lsp.lua` | LSP・補完（サーバー非依存部分） | mason, mason-lspconfig, blink.cmp, nvim-lspconfig, lazydev, mason-update-all, fidget |

詳細な LSP 設計（mason / lsp ディレクトリ / blink / キーマップ / 診断 / fidget）は [`lsp.md`](lsp.md) を参照。

## キーマップの所有

- `keymaps.lua`: 素の vim 操作の上書き・無効化、グローバルキー予約、`<plug>(my-toggle)` / `<plug>(my-tab)` プレフィックス定義。
- 各 spec の `keys=`: そのプラグイン固有のキー（lazy-load トリガー兼用）。
- 例外的な実装上の注意:
  - `<Plug>(my-toggle)X` 系（gitsigns blame `Tb`、trim `TW`）は `keys=` の lhs に `<Plug>(my-toggle)b` 等を置く。プレフィックス自体は `keymaps.lua` 依存。
  - mini.* はキーを `opts.mappings` で登録するため、lazy-load 用に `keys=` にトリガーキーを併記する。

## 言語専用 LSP プラグインの方針

- **全言語はネイティブ `lsp/<server>.lua`（`vim.lsp.config`）を既定**とする。標準 LSP 機能（定義・hover・rename・references・診断・format・code action・inlay hint）はこれで足りる。
- 言語専用プラグイン（rustaceanvim 等）は **非標準・言語固有機能（DAP・マクロ展開・専用 code action 等）を実際に使う時だけ opt-in** で足す。Rust はネイティブ `lsp/rust_analyzer.lua` のみで運用し、rustaceanvim・crates.nvim は採用しない。

## 採用しないプラグイン（棚卸しで削除）

- **rustaceanvim** / **crates.nvim**: Rust はネイティブ `lsp/rust_analyzer.lua` のみで運用（上記方針）。
- **substitute.nvim**: キーマップ未設定で実質未使用だったため削除。

## グローバルヘルパ (`util.lua`)

- `Map(mode, lhs, rhs, opts)` のみを保持する。`Dump` / `MergeTables` は未使用のため持たない。

## treesitter

nvim 0.12 で master ブランチが非対応になったため、2026-06-13 に **`main` ブランチへ移行**した（旧スコープ外メモで想定していたコンティンジェンシーの発動）。

- **ブランチ**: `branch = "main"` / `lazy = false`（main は遅延ロード非対応）/ `build = ":TSUpdate"`。
- **モジュール廃止**: main では `require("nvim-treesitter.configs").setup{}` の `highlight` / `indent` モジュールが無い。
  - ハイライトは `FileType` autocmd で `vim.treesitter.start(buf, lang)` を呼ぶ方式。`vim.treesitter.language.add` は失敗時 throw せず nil を返すため、`pcall` の **第2戻り値** で導入済み判定する。
  - **indent モジュールは採用しない**（main では実験的扱い）。自動インデントは Neovim 標準の `indentexpr` に委ねる。インデントガイド表示は従来どおり indent-blankline。
- **パーサ導入**: `require("nvim-treesitter").install({...})`（導入済みは no-op）。旧 `auto_install = true` 相当は、`FileType` 内で未導入かつ `get_available()` に含まれる lang を `install(lang):await(...)` で自動導入して再現。
- **前提**: `tree-sitter` CLI（`extra/tree-sitter-cli`, 0.26.1 以上）が必須。main はパーサを `tree-sitter build` でコンパイルするため、未導入だと全パーサの install が `ENOENT 'tree-sitter'` で失敗する。
- パーサの導入先は `stdpath("data")/site/parser`（旧 master 時代に plugin clone 配下へ残った `.so` は移行時に削除済み）。
