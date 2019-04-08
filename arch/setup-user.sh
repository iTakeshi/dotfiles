multilib_line=$(sed -n "/^#\[multilib\]$/=" /etc/pacman.conf)
if [ "$multilib_line" == "" ]; then
    exit 1
fi
sudo sed -i -e "${multilib_line}s/^#//" /etc/pacman.conf
sudo sed -i -e "$(expr $multilib_line + 1)s/^#//" /etc/pacman.conf

sudo pacman -Syyuu
sudo pacman -S git

git clone https://github.com/iTakeshi/dotfiles.git $HOME/dotfiles
ln -sf $HOME/dotfiles/home/.bash_logout .
ln -sf $HOME/dotfiles/home/.bash_profile .
ln -sf $HOME/dotfiles/home/.bashrc .
ln -sf $HOME/dotfiles/home/.config .
ln -sf $HOME/dotfiles/home/.myclirc .
ln -sf $HOME/dotfiles/home/.xinitrc .
ln -sf $HOME/dotfiles/home/.xprofile .
mkdir -p $HOME/.local/share/bash
mkdir -p $HOME/.local/share/python
cd $HOME/dotfiles
git remote set-url --push origin github:iTakeshi/dotfiles.git

git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -sri

yay -S \
    arch-diff pacman-contrib pkgfile gdisk nfs-utils neovim wget bat hexyl tym \
    openssh openconnect bash-completion words \
    xsel unzip evtest udevil hwinfo ntp nginx mariadb hping htop smartmontools tcpdump \
    autoconf automake bazel cmake clang nasm gdb cloc docker docker-compose \
    jre8-openjdk jdk8-openjdk python-pip python2-pip ruby scala sbt ammonite tk eigen

pip install --user mycli numpy PyQt5 matplotlib pynvim
pip2 install --user pynvim
sed -i -e "/^backend/s/^\(backend[ ]\+: \).*/\1Qt5Agg/" $HOME/.local/lib/python3.7/site-packages/matplotlib/mpl-data/matplotlibrc

sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo sed -i -e "/^\[mysqld\]$/a character-set-server = utf8" /etc/mysql/my.cnf
sudo systemctl start mariadb
sudo mysql_secure_installation

sudo systemctl enable ntpd
sudo systemctl enable mysqld
sudo systemctl enable devmon@$USER

read -p 'Am I equipped with nvidia GPU(s)? [y/N] > ' setup_nvidia
if [ "$setup_nvidia" == "Y" -o "$setup_nvidia" == "y" ]; then
    yay -S nvidia nvidia-utils nvidia-settings cuda cudnn
fi

read -p 'setup GUI? [Y/n] > ' setup_gui
if [ "$setup_gui" != "N" -a "$setup_gui" != "n" ]; then
    gpg --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E
    yay -S \
        xorg-server xorg-xev xorg-xauth lightdm lightdm-gtk-greeter awesome \
        fcitx fcitx-mozc fcitx-configtool fcitx-im scrot fontforge wireshark-qt \
        cbatticon freeglut alsa-utils arandr cups cups-filters "gtk3-print-backends" \
        mupdf nomacs thunar texlive-core texlive-lang ghostscript imagemagick otf-ipafont \
        gimp inkscape vlc libreoffice-fresh \
        nerd-fonts-fantasque-sans-mono dropbox google-chrome light-git snowman-git slack-desktop zoom

    amixer sset Master unmute

    sudo systemctl enable lightdm
    sudo systemctl enable cups-browsed
fi

read -p 'Am I running on the virtualbox? [y/N] > ' is_virtualbox
if [ "$is_virtualbox" == "Y" -o "$is_virtualbox" == "y" ]; then
    yay -S virtualbox-guest-utils virtualbox-guest-modules-arch
    cat << EOF | sudo tee /etc/modules-load.d/virtualbox.conf
vboxguest
vboxsf
vboxvideo
EOF
else
    yay -S virtualbox virtualbox-host-modules-arch
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
