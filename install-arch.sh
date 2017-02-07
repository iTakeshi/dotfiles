pacman -Syy
pacman -Syu

rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc

sed -i -e "20,$s/^# *\(en_US\|ja_JP\)\.UTF-8/\1\.UTF-8/g" /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

while true; do
    echo -n 'hostname? > '
    read hostname
    if [ "$hostname" == "" ]; then
        continue
    else
        break
    fi
done
echo $hostname > /etc/hostname
sed -i -e "/^::1/a 127.0.0.1\t$hostname.localdomain\t$hostname" /etc/hosts

jaist=$(sed -n "/jaist/p" /etc/pacman.d/mirrorlist)
tsukuba=$(sed -n "/tsukuba/p" /etc/pacman.d/mirrorlist)
sed -i -e "1i $jaist" /etc/pacman.d/mirrorlist
sed -i -e "1a $tsukuba" /etc/pacman.d/mirrorlist

pacman -S intel-ucode
bootctl --path=/boot install

cat << EOF > /boot/loader/loader.conf
default	arch
timeout	5
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

passwd
