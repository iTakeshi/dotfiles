if [ "$setup_wifi" == "Y" -o "$setup_wifi" == "y" ]; then
    sudo systemctl enable wpa_supplicant@$interface
    sudo systemctl start wpa_supplicant@$interface
fi
sudo systemctl enable dhcpcd@$interface
sudo systemctl start dhcpcd@$interface

multilib_line=$(sed -n "/^#\[multilib\]$/=" /etc/pacman.conf)
if [ "$multilib_line" == "" ]; then
    exit 1
fi
sudo sed -i -e "${multilib_line}s/^#//" /etc/pacman.conf
sudo sed -i -e "$(expr $multilib_line + 1)s/^#//" /etc/pacman.conf

sudo pacman -Syy

sudo pacman -S \
    xorg-server xorg-server-utils wpa_supplicant neovim \
    lightdm lightdm-gtk-greeter awesome termite git wget openssh \
    fcitx fcitx-mozc fcitx-configtool fcitx-im bash-completion xsel unzip \
    evtest udisks2 hwinfo xorg-xev ntp cbatticon nginx mariadb \
    jre8-openjdk jdk8-openjdk ruby ghc rust cargo scala sbt python-pip python2-pip nodejs npm r \
    mupdf nomacs thunar wine texlive-core texlive-lang imagemagick otf-ipafont

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

sudo pip install mycli numpy scipy PyQt5 matplotlib seaborn chainer neovim
sudo pip2 install neovim
sudo sed -i -e "/^backend/s/^\(backend[ ]\+: \).*/\1Qt5Agg/" /usr/lib/python3.6/site-packages/matplotlib/mpl-data/matplotlibrc

aur_dir=/home/$username/usr/aur
mkdir -p $aur_dir

cd $aur_dir
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome
makepkg -sri

cd $aur_dir
git clone https://aur.archlinux.org/nerd-fonts-complete.git
cd nerd-fonts-complete
makepkg -sri

cd $aur_dir
git clone https://aur.archlinux.org/light-git.git
cd light-git
makepkg -sri

cd $aur_dir
git clone https://aur.archlinux.org/dropbox.git
cd dropbox
makepkg -sri

cd $aur_dir
git clone https://aur.archlinux.org/zoom.git
cd zoom
makepkg -sri

cat << EOF | tee /etc/udev/hwdb.d/90-custom-keyboard.hwdb
evdev:input:b0003v0853p0100*
  KEYBOARD_KEY_7008a=rightmeta

evdev:input:b0011v0001p0001*
  KEYBOARD_KEY_0e=backslash
  KEYBOARD_KEY_2b=backspace
  KEYBOARD_KEY_3a=leftctrl
  KEYBOARD_KEY_9d=compose
  KEYBOARD_KEY_dd=rightmeta
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

sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo sed -i -e "/^\[mysqld\]$/a character-set-server = utf8" /etc/mysql/my.cnf
sudo systemctl start mariadb
mysql_secure_installation

sudo systemctl enable lightdm
sudo systemctl enable ntpd
sudo systemctl enable mariadb

echo -n 'setup complete. press Enter to reboot.'
read

sudo reboot
