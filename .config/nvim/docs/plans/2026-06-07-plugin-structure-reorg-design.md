# plugin 構造の役割ベース再編 — 設計記録

**作成: 2026-06-07**（この時点の design doc。確定内容は `docs/specs/plugins.md` に反映する）

## 背景・目的

`lua/plugins/*.lua` のカテゴリ別構成に、役割の不純物・設定スタイルの不統一・キーマップ所有の分散・未使用資産が蓄積していた。これらを一括で整理し、lazy.nvim 公式推奨に沿ったミニマルで一貫した構成へ再編する。

スコープは以下の4点（ユーザー合意済み）:

1. プラグインの棚卸し（不要・重複・未使用の削除）
2. ファイル分割の再編（役割ベース・単一責務）
3. 設定スタイルの統一（opts 優先）
4. キーマップ所有の整理（`keys=` 集約）

**treesitter は本スコープ外**（後述の理由により別ブレストで扱う）。

## 確定した方針（クリアした論点）

| 論点 | 決定 |
|------|------|
| ファイル分割 | **役割ごと**（1プラグイン1ファイルは不採用）。各ファイルが単一責務を持つ |
| 設定スタイル | **opts 優先**（lazy.nvim 公式の「config is almost never needed」に準拠） |
| キーマップ所有 | プラグイン固有キーは **spec の `keys=` に集約**し lazy-load トリガー兼用 |
| treesitter | 本件では触らず別ブレスト（理由は下記「調査メモ」） |
| rustaceanvim | **削除しネイティブ化** |
| crates.nvim | **削除** |

## 調査メモ（2026-06-07 時点）

### lazy.nvim 公式ドキュメント照合
- 「Always use `opts` instead of `config` when possible. `config` is almost never needed.」→ opts 優先は公式そのもの。
- `init` は `vim.g.*` を起動時に立てる用途に限定。
- lazy-load トリガーは event / cmd / ft / keys。`keys=` はロードトリガーを兼ねる。
- `{ import = "plugins" }` での複数ファイル分割は現状どおりで正しい。
- 改善余地: `event = "VeryLazy"` の多用と、トリガー無し（tabby/trim 等＝起動時ロード）を、正確な keys/cmd/ft へ寄せる。

### treesitter の状況（本件スコープ外の根拠）
- 2026-04-03、nvim-treesitter はメンテナによりアーカイブ（read-only）。
- `master`: ロック済み・0.11 後方互換用。現行設定が使う旧 API（`require("nvim-treesitter.configs").setup`）はこちら。nvim 0.12 上で当面は動作。
- `main`: 完全非互換リライト。0.12+ 必須、lazy-load 非対応（`lazy=false`）、highlight/indent は手動 autocmd 化、indent は experimental。
- 両ブランチとも現在は無保守。main は「未来」ではなく「もう一つの凍結ブランチ」。
- 結論: 当面 master を pin で据え置き、master が 0.12 で動かなくなった時点で main 直叩き or 後継（例: tree-sitter-manager.nvim）を再検討。→ **今回は treesitter.lua を変更しない**。

### 言語専用 LSP プラグインの考え方（rustaceanvim）
- ネイティブ `lsp/<server>.lua` は標準 LSP 機能（定義/hover/rename/references/診断/format/code action/inlay hint）を全てカバー。
- rustaceanvim が足すのは非標準・Rust 固有機能（DAP、runnables、expandMacro、構文木表示、grouped hover actions 等）のみ。公式 README も「始めたばかりなら組込み/ lspconfig で十分」と明言し、手動 rust_analyzer セットアップとは競合する（オール・オア・ナッシング）。
- ユーザーは非標準機能をほぼ未使用 → 純コスト。**原則: 全言語はネイティブ `lsp/<server>.lua` を既定とし、言語専用プラグインは非標準機能を実際に使う時だけ opt-in で足す。**

## ① ファイル構成（役割ベース・単一責務）

| ファイル | 役割 | プラグイン | 変更 |
|--------|------|--------|------|
| `colorscheme.lua` | 配色 | sonokai | ui.lua から分離（新規） |
| `ui.lua` | UI chrome・通知・アイコン | noice, nvim-notify, nui, nvim-web-devicons, inspecthi | sonokai を外す／inspecthi をここへ |
| `statusline.lua` | ステータス/タブライン | lualine, tabby | 変更なし（②③は適用） |
| `treesitter.lua` | 構文・インデント表示 | treesitter, indent-blankline | 本件では触らない |
| `editing.lua` | 編集オペレータ・テキストオブジェクト | mini.align/comment/surround, yanky, trim, vim-textobj-{user,line,url,parameter} | operators.lua + editor.lua の編集系を統合（新規）。substitute は削除 |
| `git.lua` | Git 連携 | gitsigns, diffview, lazygit | gitsigns を editor.lua から移動 |
| `fuzzy.lua` | ファインダ | fzf-lua | 変更なし（②③は適用） |
| `terminal.lua` | 端末 | toggleterm | 変更なし（②③は適用） |
| `yazi.lua` | ファイラ | yazi | 変更なし（②③は適用） |
| `lsp.lua` | LSP・補完 | mason, mason-lspconfig, blink.cmp, nvim-lspconfig, lazydev, mason-update-all, fidget | rustaceanvim・crates.nvim を削除 |

**削除されるファイル**: `editor.lua`、`operators.lua`（中身を git.lua / editing.lua / ui.lua へ分配）。

inspecthi（ハイライト確認ツール）は配色/ハイライト関連のため `ui.lua` に同居させる。

## ② 設定スタイル（opts 優先・公式準拠）

- `require().setup()` を呼ぶだけの `config` 関数は **`opts` テーブルに置換**。
- `config` / `init` / 関数は **副作用（autocmd・`<Plug>` 以外のキー・`vim.g.*`）がある時だけ**使用。
- **lazy トリガーの正確化**: `event = "VeryLazy"` でも `keys`/`cmd`/`ft` で表せるものは置換。トリガー無し（tabby/trim 等）にも適切なトリガーを付与する。

## ③ キーマップ（keys= 集約）

- プラグイン固有キーは **spec の `keys=`** に集約（lazy-load トリガー兼用）。`config`/`on_attach` 内の `Map()` 定義（gitsigns・trim・yanky 等）を `keys=` へ移設する。
- `keymaps.lua` には**素の vim 操作とグローバル予約**（`<plug>(my-toggle)` / `<plug>(my-tab)` のプレフィックス定義含む）のみを残す。
- 注意が要る2ケース:
  - **`<Plug>(my-toggle)X` 系**（gitsigns `b`、trim `W`）: `keys=` の lhs に `<Plug>(my-toggle)b` を置けるが、プレフィックス（`T` → `<plug>(my-toggle)`）は keymaps.lua 依存。lazy 化後の発火を実機確認する。
  - **mini.\***: キーは `opts.mappings` で登録されるため、lazy-load 用に `keys=` へトリガーキーを併記する形にする。

## ④ 棚卸し（プルーニング）

- **rustaceanvim 削除** → `lsp/rust_analyzer.lua` 新規作成（settings: clippy / allFeatures / loadOutDirsFromCheck / buildScripts / procMacro を移植）。`mason-lspconfig` の `automatic_enable.exclude` から `rust_analyzer` を除去し、他言語と同一扱いに。
- **crates.nvim 削除**（Cargo.toml の crates.io 連携を廃止）。
- **substitute.nvim 削除**（キーマップ未設定で実質未使用だった）。
- **未使用グローバルヘルパ削除**: `util.lua` の `Dump` / `MergeTables`（いずれも自己参照のみで外部利用ゼロ）。`Map` は継続。
- lazy トリガー無しプラグインの起動時ロードを解消（②と連動）。

## ⑤ 検証

このリポジトリにはユニットテストが無いため手動検証:

- ロード: `nvim --headless "+lua print('ok')" +qa` がエラーなく終了。
- 各 ft で対象プラグイン/LSP が attach すること。特に rust ファイルで `lsp/rust_analyzer.lua` 経由の `rust_analyzer` が attach し、`:RustLsp` コマンドが存在しないこと。Cargo.toml で crates 補完が出ないこと。
- 主要キーマップの動作: fzf `<c-p>`、yanky `p`/`P`、mini.surround `gsa`、toggle `Tb`（gitsigns blame）/`TW`（trim）、`<leader>ih`（inlay hint）。
- `chezmoi status` で nvim 配下の差分が全て取り込まれていること。

## 反映先

- 確定設計は `docs/specs/plugins.md`（design-of-record）に反映する。
- 実装計画は writing-plans により別途 `docs/plans/2026-06-07-plugin-structure-reorg.md` 等として作成する。
