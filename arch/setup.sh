ethernet=$(ip link | sed -n -e "/<BROADCAST/s/^[0-9]: \(.*\): <BROADCAST.*$/\1/p")
systemctl start dhcpcd@$ethernet
systemctl enable dhcpcd@$ethernet

pacman -S sudo
while true; do
    echo -n 'username? > '
    read username
    if [ "$username" == "" ]; then
        continue
    else
        break
    fi
done
useradd -m -G wheel $username
passwd $username
echo -n 'Now, uncomment "%wheel ALL=(ALL) ALL" in the sudoers file to enable sudo. Press enter to open visudo.'
read
visudo

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
    scala sbt python-pip python2-pip tk unzip

mkdir -p /home/$username/usr/aur
cd /home/$username/usr/aur
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome
makepkg -sri

cat << EOF > /etc/udev/hwdb.d/90-custom-keyboard.hwdb
evdev:input:b0003v0853p0100*
  KEYBOARD_KEY_7008a=rightmeta
EOF
udevadm hwdb --update
udevadm trigger

systemctl enable sddm
