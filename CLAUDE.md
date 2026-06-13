# System Configuration

Fresh Arch Linux setup. This file summarizes the foundational tooling outside of Hyprland.

## Package Management -- OUTDATED; to be updated

### Packages
Idempotent installs via `--needed`:

```
sudo pacman -S --needed - < packages.txt
paru -S --needed - < packages-aur.txt
```

Export current state:
```
pacman -Qqen > packages.txt
pacman -Qqem > packages-aur.txt
```

### /etc
Managed with `pacdiff` — reviews `.pacnew` files after package updates.

## AUR Helper — paru

`paru` is the AUR helper in use on this machine.

## Dotfile Management — yadm

`$HOME` 自体が git の work-tree。`yadm add/commit/push` が素の git の1フローで完結する。

```
yadm status            # 普通の git status（untracked も表示する。後述）
yadm add <file>        # 明示ファイル add（ディレクトリ一括にはしない）
yadm commit            # 履歴に記録
yadm push              # origin へ
```

- **リモート**: `git@github.com:iTakeshi/dotfiles.git`（private・オフサイトバックアップ兼用）。ブランチは `main`。

### untracked を表示させる方針

yadm のドキュメント既定は `status.showUntrackedFiles = no`（ホームの無数のファイルを隠すため）。本環境では**あえて設定せず**、git 既定（`normal`）のまま untracked を表示させる。普通の git repo と同じ感覚で運用し、追跡漏れ・新規ファイルを `yadm status` で発見できるようにするため。代わりに **`.gitignore` を明示管理**してノイズを制御する。

### 階層化した .gitignore 戦略

untracked を表示する方針なので、何を無視するかを `.gitignore` で正確に設計する。階層ごとに方式を変えている:

- **`~/.gitignore` — allowlist 方式**。`/*` で全無視してから `!` で許可項目だけ開ける（`/.config/`, `/.gitignore`, `/.zshrc`, `/README.md`）。`.ssh/` `.aws/` `.gnupg/` `.docker/` 等の秘密が**事故で混入しない**ことを構造的に保証する。加えて `**/.claude/settings.local.json` を全階層で deny。
- **`~/.config/.gitignore` — denylist 方式**。既知の不要ディレクトリ／ファイルだけ無視（`dconf/` `fcitx*/` `google-chrome/` `gtk-3.0/` `htop/` `ibus/` `mise/` `mozc/` `pulse/` `uv/`, `mimeapps.list`, `pavucontrol.ini`）。新しい config が増えたとき `yadm status` に untracked として現れ、**追跡判断を促す**のが狙い。

- **`~/.config/* (claude や nvim 等)` — 方式自由**。特性に応じてallowlistとdenylistを使い分ける。allowlistの場合は `/*` で全無視したあとに `/.gitignore` を許可するのを忘れないこと。

> `~/.config/git/ignore` は別物で、**全 git repo に効く core.excludesfile**（macOS ゴミ等のグローバル無視）。yadm の `.gitignore` 群とは役割が違う。

### 秘密のスキャン — detect-secrets（pre_commit フック）

`.gitignore` の allowlist 防御だけでは「追跡対象ファイルの中身にベタ書きされた秘密」は防げない。これを `Yelp/detect-secrets`（`uvx --from detect-secrets …`、システムには未インストール）で補う。**コミットのたびに自動実行し、baseline に無い未知の検出があれば commit を reject** する運用。

構成（すべて yadm 追跡 → 他マシンでも `yadm clone` するだけで有効。`uvx` だけ前提）:

- **フック**: `~/.config/yadm/hooks/pre_commit`（実行ビット必須）。yadm の pre_ フックは非ゼロ終了で `yadm commit` を中止する（`man yadm` HOOKS）。`YADM_HOOK_REPO`/`YADM_HOOK_WORK` でステージ済みファイル（`--diff-filter=ACM`）を取得し `detect-secrets-hook` に渡す。**注意: 標準 git の `pre-commit` ではなく yadm 独自フック名 `pre_commit`（アンダースコア）**。`yadm commit` 経由でのみ発火する（生 git commit では走らない）。
- **ベースライン**: `~/.config/yadm/secrets.baseline`。`$HOME` 直下に置くと `~/.gitignore` の allowlist で弾かれて追跡できないため `.config/` 配下に置く。既知誤検知ゼロのクリーン状態（`results: {}`）。
- **除外**: `lazy-lock\.json` を `--exclude-files` で除外（後述）。

```bash
# ベースライン再生成（追跡ファイルのみ・lazy-lock 除外）。$HOME 相対パスなので必ず ~ で
cd ~ && uvx --from detect-secrets detect-secrets scan $(yadm ls-files) \
  --exclude-files 'lazy-lock\.json' > ~/.config/yadm/secrets.baseline
```

新規ファイル追加で正規の秘密でない高エントロピー文字列が増えたら、上記でベースラインを再生成して `yadm add` し直す。`xargs -0` 経由は `>` がバッチ毎に上書きするので使わない（追跡セットはパスに空白なし＝`$(...)` で安全）。

**既知の誤検知 — `lazy-lock.json`（exclude 運用に確定）**: lazy.nvim のロックファイルで各行が git コミットSHA（40桁 hex）。`Hex High Entropy String` として大量に拾われるが秘密ではない。更新のたびに `audit` し直すのは手間で、ここに手動で秘密を書くこともないため **`--exclude-files 'lazy-lock\.json'` で除外**する方針（フック・ベースライン生成の両方で指定）。2026-06-14 時点のフルスキャンで実際の秘密混入はゼロ。

## Shell — zsh + oh-my-zsh

実シェルは **zsh**（`chsh -s /usr/bin/zsh`）。設定は `~/.zshrc`（追跡対象）。マシン固有の上書きは `~/.zshrc.local`（追跡しない）。
