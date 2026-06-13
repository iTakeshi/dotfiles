# Neovim 設定プロジェクト

`~/.config/nvim` の Neovim 設定。yadm 管理（`$HOME` が work-tree）。変更後は対象ファイルを `yadm add` → `yadm commit` で追跡へ反映する（`spell/` は除外）。

## ドキュメント

### "memorize" 指示への対応

ユーザーが "memorize" または "覚えて" と言ったときは、**Claude Code の auto-memory ではなく** `CLAUDE.md` または `docs/` を更新すること。auto-memory への書き込みは行わない。

内容に応じて保存先を選ぶ:
- システム仕様の変更 → `docs/specs/` の該当ファイルを更新
- 運用知識・how-to・設計メモ → `docs/notes/` に追加・更新
- Claude への永続的な作業指示 → `CLAUDE.md` に追記

### 「現在の作業状況」の維持方針

- **完了作業の記録は CLAUDE.md に残さない**（バグ修正の逐次ログも不要）。spec に影響する変更は `docs/specs/` を更新し、それ以外は記録せず破棄する。
- 「現在の作業状況」内の **「直近の残課題」には未完作業のみ**を置き、常に最新化する。完了した項目は削除し、過去の完了ログ（「前回」等）は残さない。

### docs/ の使い方ルール

`docs/` は **`specs/`**・**`plans/`**・**`notes/`** の 3 フォルダで構成する。他のフォルダは作らない。

> superpowers 系スキル（brainstorming / writing-plans 等）は既定で `docs/superpowers/specs` や `docs/superpowers/plans` に書き込もうとするが、本 PJ ではこの規約が優先する。spec は `docs/specs/`、plan は `docs/plans/` に置く。

#### `docs/specs/` — 仕様（design-of-record）

- プロジェクトの**確定した設計**を定義するドキュメントを置く。**設計が確定した時点で更新し、実装完了を待たない**（design-of-record）。
- まだ実装されていない設計は **「設計済み・未実装」と明示する**（見出し脇のタグや注記で状態を示す）。実装が完了したらその注記を外す。実装と設計がずれたら、設計どおりに実装するか設計を更新するかのどちらかで必ず解消する（古い内容を放置しない）。
- 設計確定のプロセス: brainstorming → `docs/plans/` に日付付き design doc（その時点の設計記録）→ **確定内容を `docs/specs/` にも反映** → 実装。plans/ は歴史的記録、specs/ は常に最新の design-of-record。
- **ファイル名にタイムスタンプを付けない**（常に最新化される前提のため）
- 各ファイルの先頭に `**最終更新: YYYY-MM-DD**` を記載する

| ファイル | 内容 |
|--------|------|
| `plugins.md` | プラグイン構造の design-of-record（役割ベースのファイル分割 / opts 優先 / keys= 集約 / 言語専用 LSP 方針） |
| `lsp.md` | LSP 設定の design-of-record（mason / lsp ディレクトリ / blink / キーマップ / rust / fidget） |

#### `docs/notes/` — 運用知識・how-to・設計メモ

- 仕様でも実装計画でもない、**実運用や開発に役立つ知識**を置く
- **ファイル名にタイムスタンプを付けない**（継続的に更新される前提）
- 各ファイルの先頭に `**最終更新: YYYY-MM-DD**` を記載する
- 内容が古くなったら更新する
- まだ中身が無いため空フォルダは作らない。最初のメモを書く時に作成する。

#### `docs/plans/` — 作業計画（歴史的文書）

- ある中間状態から次の状態へ進むための**実装計画**、およびその時点の設計記録（design doc）を置く
- **ファイル名は `YYYY-MM-DD-{topic}.md` 形式**（タイムスタンプ必須）
- 作業完了後も削除せず歴史的文書として保存する
- 完了済み計画の内容は編集しない

| ファイル | 内容 |
|--------|------|
| `2026-06-06-lsp-nvim012-modernization-design.md` | LSP モダナイゼーション設計記録 (完了) |
| `2026-06-07-lsp-nvim012-modernization.md` | LSP モダナイゼーション実装計画 (完了) |
| `2026-06-07-plugin-structure-reorg-design.md` | プラグイン構造 役割ベース再編 設計記録 |
| `2026-06-10-plugin-structure-reorg.md` | プラグイン構造 役割ベース再編 実装計画 |
