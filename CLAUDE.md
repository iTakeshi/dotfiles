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

## Shell — zsh + oh-my-zsh

実シェルは **zsh**（`chsh -s /usr/bin/zsh`）。設定は `~/.zshrc`（追跡対象）。マシン固有の上書きは `~/.zshrc.local`（追跡しない）。
