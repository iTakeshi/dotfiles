multilib_line=$(sed -n "/^#\[multilib\]$/=" /etc/pacman.conf)
if [ "$multilib_line" == "" ]; then
    exit 1
fi
sudo sed -i -e "${multilib_line}s/^#//" /etc/pacman.conf
sudo sed -i -e "$(expr $multilib_line + 1)s/^#//" /etc/pacman.conf

aur_dir=/$HOME/usr/aur
mkdir -p $aur_dir

function install_aur () {
    cd $aur_dir
    git clone https://aur.archlinux.org/$1.git
    cd $1
    makepkg -sri
}

sudo pacman -Syy

sudo pacman -S \
    pkgfile gdisk nfs-utils neovim git wget openssh openconnect bash-completion words \
    xsel unzip evtest udevil hwinfo ntp nginx mariadb hping htop smartmontools tcpdump \
    autoconf automake bazel cmake clang nasm gdb cloc \
    jre8-openjdk jdk8-openjdk rust cargo python-pip python2-pip tk eigen

install_aur arch-diff

pip install --user mycli numpy scipy PyQt5 matplotlib seaborn chainer neovim pipenv
pip2 install --user neovim
sed -i -e "/^backend/s/^\(backend[ ]\+: \).*/\1Qt5Agg/" $HOME/.local/lib/python3.6/site-packages/matplotlib/mpl-data/matplotlibrc

cd $HOME
git clone https://github.com/iTakeshi/dotfiles.git
ln -sf /$HOME/dotfiles/home/.bash_logout .
ln -sf /$HOME/dotfiles/home/.bash_profile .
ln -sf /$HOME/dotfiles/home/.bashrc .
ln -sf /$HOME/dotfiles/home/.config .
ln -sf /$HOME/dotfiles/home/.myclirc .
ln -sf /$HOME/dotfiles/home/.gitconfig .
ln -sf /$HOME/dotfiles/home/.gitignore_global .
ln -sf /$HOME/dotfiles/home/.xinitrc .
ln -sf /$HOME/dotfiles/home/.xprofile .
cd $HOME/dotfiles
git remote set-url --push origin github:iTakeshi/dotfiles.git

sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo sed -i -e "/^\[mysqld\]$/a character-set-server = utf8" /etc/mysql/my.cnf
sudo systemctl start mariadb
sudo mysql_secure_installation

sudo systemctl enable ntpd
sudo systemctl enable mysqld
sudo systemctl enable devmon@$USER

read -p 'setup GUI? [Y/n] > ' setup_gui
if [ "$setup_gui" != "N" -a "$setup_gui" != "n" ]; then
    sudo pacman -S \
        xorg-server xorg-xev xorg-xauth lightdm lightdm-gtk-greeter light-locker awesome \
        termite fcitx fcitx-mozc fcitx-configtool fcitx-im scrot fontforge wireshark-qt \
        cbatticon freeglut alsa-utils arandr cups cups-filters "gtk3-print-backends" \
        mupdf nomacs thunar texlive-core texlive-lang ghostscript imagemagick otf-ipafont \
        gimp inkscape vlc libreoffice-fresh

    amixer sset Master unmute

    install_aur dropbox
    install_aur google-chrome
    install_aur light-git
    install_aur nerd-fonts-complete
    install_aur snowman-git
    install_aur slack-desktop
    install_aur zoom

    sudo systemctl enable lightdm
    sudo systemctl enable cups-browsed
fi

read -p 'Am I running on the virtualbox? [y/N] > ' is_virtualbox
if [ "$is_virtualbox" == "Y" -o "$is_virtualbox" == "y" ]; then
    sudo pacman -S virtualbox-guest-utils virtualbox-guest-modules-arch
    cat << EOF | sudo tee /etc/modules-load.d/virtualbox.conf
vboxguest
vboxsf
vboxvideo
EOF
else
    sudo pacman -S virtualbox virtualbox-host-modules-arch
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

echo -n 'setup complete. press Enter to reboot.'
read

sudo reboot
