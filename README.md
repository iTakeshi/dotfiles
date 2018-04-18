iTakeshi's dotfiles
====================

## DISCLAIMER
THIS REPOSITORY IS DEVELOPED FOR MY PERSONAL USE.
You can use it freely under, but ABSOLUTELY NO WARRANTY AND SUPPORT.

## Automated ArchLinux Installation
You have to do by yourself until `arch-chroot`,
as described in [Arch wiki](https://wiki.archlinux.org/index.php/Installation_guide).

TL; DR
```sh
ls /sys/firmware/efi/efivars        # check EFI boot

# if you have to setup wifi
ip link                             # check wifi device
ip link set <DEVICE> up
wpa_passphrase <SSID> <PSK_KEY> > /etc/wpa_supplicant/wifi.conf
wpa_supplicant -B -i <DEVICE> -c /etc/wpa_supplicant/wifi.conf
dhcpcd -b <DEVICE>
# end if

ping archlinux.org                  # check internet connection
timedatectl set-ntp true            # update the system clock
gdisk /dev/sdx                      # create partitions
mkfs.ext4 /dev/sdxi                 # format `/` with ext4
mkfs.vfat /dev/sdxj                 # format `/boot` with fat32 (unless constructing dual-boot with Windows)
mkswap /dev/sdxk                    # if you setup swap partition

# mount filesystems
mount /dev/sdxn /mnt
mkdir /mnt/boot
mount /dev/sdxm /mnt/boot

vi /etc/pacman.d/mirrorlist         # select the nearest mirror [jaist > tsukuba > aggregate (for fallback)]
pacstrap /mnt base base-devel       # install system
genfstab -U /mnt >> /mnt/etc/fstab  # configure fstab
```

Then chroot to the new system, download custom install script, and execute it.
```sh
arch-chroot /mnt
curl -L -o install.sh https://goo.gl/wkKyfT
bash install.sh
```
From this point, what you have to do is just hitting RETURN key (...and supplying some information about you)

After the script finishes, reboot the machine.
```sh
exit            # from chroot-ed environment
umount -R /mnt  # can be skipped
reboot          # ...and remove installation media
```

Then, login as the root user and do another setup. In this process, you can set up LDAP authentication.
```sh
bash setup-root.sh
# CTRL-D to log out
```

Now you can login with your username (not root).
The install script should have created another setup script in your home directory,
so execute it with `bash setup-user.sh`.
Again, just hit the RETURN key.
This setup script automatically reboots the machine.

After reboot, you can use almost same environment which I use.
But some settings should be done by hand.

1. start dropbox, login, and setup autostart with `systemctl --user enable dropbox`
2. configure multi-monitor using `arandr`.
3. enable mozc via fcitx-configtool
4. (...and probably more. WIP)

