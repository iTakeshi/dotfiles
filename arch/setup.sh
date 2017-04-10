ethernet=$(ip link | sed -n -e "/<BROADCAST/s/^[0-9]: \(.*\): <BROADCAST.*$/\1/p")
systemctl start dhcpcd@$ethernet
systemctl enable dhcpcd@$ethernet

echo -n 'Am I running on the virtualbox? [y/N] > '
read is_virtualbox
if [ "$is_virtualbox" == "Y" -o "$is_virtualbox" == "y" ]; then
    pacman -S virtualbox-guest-utils virtualbox-guest-modules-arch
    cat << EOF > /etc/modules-load.d/virtualbox.conf
vboxguest
vboxsf
vboxvideo
EOF
fi

pacman -S \
    xorg-server xorg-server-utils sddm plasma-meta phonon-qt5-vlc phonon-qt4-vlc kde-applications-meta \
    noto-fonts-cjk fcitx fcitx-mozc fcitx-configtool fcitx-im dropbox alsa-utils evtest openssh \
    jre8-openjdk jdk8-openjdk ruby ghc rust cargo scala sbt python-pip python2-pip tk \
    mysql docker unzip bash-completion xsel termite

pip install mycli numpy scipy matplotlib seaborn chainer neovim
pip2 install neovim

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

cat << EOF > /etc/udev/hwdb.d/90-custom-keyboard.hwdb
evdev:input:b0003v0853p0100*
  KEYBOARD_KEY_7008a=rightmeta
EOF
udevadm hwdb --update
udevadm trigger

systemctl enable sddm

mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sed -i -e "/^\[mysqld\]$/a character_set_server = utf8"
sed -i -e "/^\[mysqld\]$/a character_set_client = utf8"
sed -i -e "/^\[mysqld\]$/a collation_server     = utf8_general_ci"
sed -i -e "/^\[mysqld\]$/a init_connect         = 'SET collation_connection = utf8_general_ci,NAMES utf8'"
systemctl restart mysqld
systemctl enable mysqld
echo -n 'MySQL password? > '
read mysql_password
cat << SQL | mysql -u root -p
create user '$username'@'localhost' identified by '$mysql_password';
grant all privileges on *.* to 'itakeshi'@'localhost';
flush privileges;
SQL
mysql_secure_installation

echo -n 'setup complete. press Enter to reboot.'
read
reboot
