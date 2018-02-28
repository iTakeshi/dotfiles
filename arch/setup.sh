multilib_line=$(sed -n "/^#\[multilib\]$/=" /etc/pacman.conf)
if [ "$multilib_line" == "" ]; then
    exit 1
fi
sudo sed -i -e "${multilib_line}s/^#//" /etc/pacman.conf
sudo sed -i -e "$(expr $multilib_line + 1)s/^#//" /etc/pacman.conf

sudo pacman -Syy

sudo pacman -S \
    xorg-server xorg-xev xorg-xauth neovim \
    lightdm lightdm-gtk-greeter awesome termite git wget openssh openconnect \
    fcitx fcitx-mozc fcitx-configtool fcitx-im bash-completion xsel unzip scrot \
    fontforge freeglut tcpdump wireshark-qt \
    evtest udevil hwinfo ntp cbatticon nginx hping htop smartmontools \
    autoconf automake cloc cmake clang eigen nasm gdb \
    jre8-openjdk jdk8-openjdk rust cargo scala sbt python-pip python2-pip nodejs npm tk \
    mupdf nomacs thunar texlive-core texlive-lang ghostscript imagemagick otf-ipafont \
    alsa-utils pkgfile gdisk nfs-utils arandr cups cups-filters gtk3-print-backends words \
    gimp inkscape vlc libreoffice-fresh

amixer sset Master unmute

read -p 'Am I running on the virtualbox? [y/N] > ' is_virtualbox
if [ "$is_virtualbox" == "Y" -o "$is_virtualbox" == "y" ]; then
    sudo pacman -S virtualbox-guest-utils virtualbox-guest-modules-arch
    sudo cat << EOF > /etc/modules-load.d/virtualbox.conf
vboxguest
vboxsf
vboxvideo
EOF
else
    sudo pacman -S virtualbox virtualbox-host-modules-arch
    sudo /sbin/vboxreload
fi

aur_dir=/home/$username/usr/aur
mkdir -p $aur_dir

function install_aur () {
    cd $aur_dir
    git clone https://aur.archlinux.org/$1.git
    cd $1
    makepkg -sri
}

install_aur arch-diff
install_aur bazel
install_aur dropbox
install_aur google-chrome
install_aur light-git
install_aur mysql
install_aur nerd-fonts-complete
install_aur snowman-git
install_aur slack-desktop
install_aur zoom

sudo pip install mycli numpy scipy PyQt5 matplotlib seaborn chainer neovim
sudo pip2 install neovim
sudo sed -i -e "/^backend/s/^\(backend[ ]\+: \).*/\1Qt5Agg/" /usr/lib/python3.6/site-packages/matplotlib/mpl-data/matplotlibrc

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

cd $HOME
git clone https://github.com/iTakeshi/dotfiles.git
ln -sf /home/$username/dotfiles/home/.bash_logout .
ln -sf /home/$username/dotfiles/home/.bash_profile .
ln -sf /home/$username/dotfiles/home/.bashrc .
ln -sf /home/$username/dotfiles/home/.config .
ln -sf /home/$username/dotfiles/home/.myclirc .
ln -sf /home/$username/dotfiles/home/.gitconfig .
ln -sf /home/$username/dotfiles/home/.gitignore_global .
ln -sf /home/$username/dotfiles/home/.xinitrc .
ln -sf /home/$username/dotfiles/home/.xprofile .

sudo mkdir -p /var/log/mysql
cat << EOF | sudo tee /etc/my.cnf
[mysqld]
general_log=1
log_output=FILE
general_log_file=/var/log/mysql/query.log

character-set-server=utf8

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
EOF
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl start mysqld
mysql_secure_installation

sudo systemctl enable lightdm
sudo systemctl enable ntpd
sudo systemctl enable mysqld
sudo systemctl enable cups-browsed
sudo systemctl enable devmon@$username

echo -n 'setup complete. press Enter to reboot.'
read

sudo reboot
