rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc

sed -i -e "/UTF-8/s/^# \?\(en_US\|ja_JP\)/\1/g" /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

while true; do
    read -p 'hostname? > ' hostname
    if [ "$hostname" == "" ]; then
        continue
    else
        break
    fi
done
echo $hostname > /etc/hostname
sed -i -e "/^::1/a 127.0.0.1\t$hostname.localdomain\t$hostname" /etc/hosts

pacman -S intel-ucode
bootctl --path=/boot install

cat << EOF > /boot/loader/loader.conf
default	arch
timeout	2
editor	0
EOF

partuuid=$(blkid | sed -n -e '/Linux x86-64 root/s/.*PARTUUID="\(.*\)".*/\1/p')
if [ "$partuuid" == "" ]; then
    echo "PARTUUID is blank. check your GPT and set the PARTLABEL of the partition for `/` to \"Linux x86-64 root (/)\"" 1>&2
    exit 1
fi
cat << EOF > /boot/loader/entries/arch.conf
title	Arch Linux
linux	/vmlinuz-linux
initrd	/intel-ucode.img
initrd	/initramfs-linux.img
options	root=PARTUUID=$partuuid rw
EOF

interface=$( echo $(ip link | sed -n -e "/<BROADCAST/s/^[0-9]: \(.*\): <BROADCAST.*$/\1/p") | cut -f 1 -d " ")
read -p 'setup wifi? [y/N] > ' setup_wifi
if [ "$setup_wifi" == "Y" -o "$setup_wifi" == "y" ]; then
    pacman -S wpa_supplicant

    while true; do
        read -p 'ssid? > ' ssid
        if [ "$ssid" == "" ]; then
            continue
        else
            break
        fi
    done

    while true; do
        read -s -p 'psk key? > ' psk
        if [ "$psk" == "" ]; then
            continue
        else
            break
        fi
    done

    cat << EOF > /etc/wpa_supplicant/wpa_supplicant-$interface.conf
ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=wheel
update_config=1
fast_reauth=1
ap_scan=1

EOF
    wpa_passphrase $ssid $psk >> /etc/wpa_supplicant/wpa_supplicant-$interface.conf
    systemctl enable wpa_supplicant@$interface
fi
systemctl enable dhcpcd@$interface

passwd
pacman -S sudo
echo -n 'Now, uncomment "%wheel ALL=(ALL) ALL" in the sudoers file to enable sudo. Press enter to open visudo.'
read
EDITOR=vi visudo

while true; do
    read -p 'username? > ' username
    if [ "$username" == "" ]; then
        continue
    else
        break
    fi
done
useradd -m -G wheel $username
passwd $username

curl -o /home/$username/setup.sh https://raw.githubusercontent.com/iTakeshi/dotfiles/master/arch/setup.sh
chown $username /home/$username/setup.sh
echo -n 'Installation has been successfully done. Reboot the machine and login as $username.'
