ethernet = $(ip link | sed -n -e "/<BROADCAST/s/^[0-9]: \(.*\): <BROADCAST.*$/\1/p")
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

pacman -S xorg-server xorg-server-utils sddm plasma-meta phonon-qt5-vlc phonon-qt4-vlc kde-applications-meta neovim chromium git
systemctl enable sddm
