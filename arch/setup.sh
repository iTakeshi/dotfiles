#!/bin/bash -euvx

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

multilib_line=$(sed -n "/^#\[multilib\]$/=" /etc/pacman.conf)
if [ "$multilib_line" == "" ]; then
    exit 1
fi
sudo sed -i -e "${multilib_line}s/^#//" /etc/pacman.conf
sudo sed -i -e "$(("$multilib_line" + 1))s/^#//" /etc/pacman.conf

sudo pacman -Syyuu
sudo pacman -S git

git clone https://github.com/iTakeshi/dotfiles.git "$HOME/dotfiles"
ln -sf "$HOME/dotfiles/home/.bash_logout" "$HOME"
ln -sf "$HOME/dotfiles/home/.bash_profile" "$HOME"
ln -sf "$HOME/dotfiles/home/.bashrc" "$HOME"
ln -sf "$HOME/dotfiles/home/.config" "$HOME"
ln -sf "$HOME/dotfiles/home/.xprofile" "$HOME"
mkdir -p "$HOME/.local/share/bash"
mv "$HOME/.bash_history" "$HOME/.local/share/bash/history"
mkdir -p "$HOME/.local/share/python"
mkdir -p "$HOME/.local/share/mycli"
mkdir -p "$HOME/.local/share/rlwrap"
cd "$HOME/dotfiles"
git remote set-url --push origin github:iTakeshi/dotfiles.git

git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -sri

yay --removemake --S \
    arch-diff pacman-contrib pkgfile gdisk nfs-utils ntfs-3g neovim wget bat hexyl tym \
    openssh openconnect bash-completion words man ddrescue pdftk plantuml tmux rlwrap \
    xsel unzip evtest devmon hwinfo ntp nginx mariadb hping htop smartmontools tcpdump \
    bazel cmake clang maven ninja nasm gdb cloc doxygen graphviz docker docker-compose docker-machine \
    jre8-openjdk jdk8-openjdk tk ruby eigen scala sbt nodejs npm yarn rustup go dotnet-runtime

gem install neovim
npm install --userconfig "$XDG_CONFIG_HOME/npm/npmrc" -g neovim

git clone https://github.com/pyenv/pyenv.git ~/.local/share/pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.local/share/pyenv/plugins/pyenv-virtualenv
git clone https://github.com/momo-lab/pyenv-install-latest.git ~/.local/share/pyenv/plugins/pyenv-install-latest

sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo sed -i -e "/^\[mysqld\]$/a collation-server = utf8mb4_unicode_ci" /etc/my.cnf.d/server.cnf
sudo sed -i -e "/^\[mysqld\]$/a init-connect = 'SET NAMES utf8mb4'" /etc/my.cnf.d/server.cnf
sudo sed -i -e "/^\[mysqld\]$/a character-set-server = utf8mb4" /etc/my.cnf.d/server.cnf
sudo sed -i -e "/^\[client\]$/a default-character-set = utf8mb4" /etc/my.cnf.d/client.cnf
sudo sed -i -e "/^\[mysql\]$/a default-character-set = utf8mb4" /etc/my.cnf.d/mysql-clients.cnf
sudo systemctl start mariadb
sudo mysql_secure_installation

sudo systemctl enable ntpd
sudo systemctl enable mysqld
sudo systemctl enable "devmon@$USER"

sudo usermod -aG docker "$USER"
sudo systemctl enable docker

read -r -p "Am I equipped with nvidia GPU(s)? [y/N] > " setup_nvidia
if [ "$setup_nvidia" == "Y" ] || [ "$setup_nvidia" == "y" ]; then
    yay --removemake -S nvidia nvidia-utils nvidia-settings cuda cudnn
fi

read -r -p "setup GUI? [Y/n] > " setup_gui
if [ "$setup_gui" != "N" ] && [ "$setup_gui" != "n" ]; then
    gpg --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E  # for dropbox
    yay --removemake -S \
        xorg-server xorg-xev xorg-xauth xorg-xrdb lightdm lightdm-gtk-greeter awesome \
        fcitx fcitx-mozc fcitx-configtool fcitx-im scrot fontforge wireshark-qt xdotool \
        cbatticon freeglut alsa-utils arandr cups cups-filters gtk3-print-backends \
        mupdf pdfmod nomacs thunar texlive-core texlive-langjapanese ghostscript imagemagick otf-ipafont noto-fonts-cjk \
        gimp inkscape mpv libreoffice-fresh-ja \
        nerd-fonts-fantasque-sans-mono dropbox google-chrome light-git slack-desktop zoom

# TODO 2020-01-22
# PKGBUILD for texlive-localmanager-git is broken now

    amixer sset Master unmute

    sudo systemctl enable lightdm
    sudo systemctl enable cups-browsed
fi

read -r -p "Am I running on the virtualbox? [y/N] > " is_virtualbox
if [ "$is_virtualbox" == "Y" ] || [ "$is_virtualbox" == "y" ]; then
    yay --removemake -S virtualbox-guest-utils virtualbox-guest-modules-arch
    cat << EOF | sudo tee /etc/modules-load.d/virtualbox.conf
vboxguest
vboxsf
vboxvideo
EOF
else
    yay --removemake -S virtualbox virtualbox-host-modules-arch
    sudo /sbin/vboxreload

    cat << EOF | sudo tee /etc/udev/hwdb.d/90-custom-keyboard.hwdb
evdev:input:b0003v0853p0100*
  KEYBOARD_KEY_7008a=rightmeta
  KEYBOARD_KEY_7008b=leftmeta

evdev:input:b0011v0001p0001*
  KEYBOARD_KEY_0e=backslash
  KEYBOARD_KEY_2b=backspace
  KEYBOARD_KEY_3a=leftctrl
  KEYBOARD_KEY_9d=rightmeta
  KEYBOARD_KEY_dd=compose
EOF
    sudo udevadm hwdb --update
    sudo udevadm trigger
fi

cat << EOF
setup complete. press Enter to reboot.

TODO after re-login:
  1) execute $HOME/dotfiles/arch/setup-pyenv.sh
  2) setup dropbox
  3) enable mozc via fcitx-configtool
  4) monitor config using arandr (with .Xresources for dpi tweaking)
  5) ... and more?
EOF
read -r

sudo reboot
