Before executing `arch/install.sh`, lines relating to `useradd` should be removed.
Also home directory for the primary user should be created and `chown $ldapuser:$ldapgroup`.

```sh
pacman -S sssd
vi /etc/sssd/sssd.conf
vi /etc/nscd.conf 
vi /etc/nsswitch.conf 
vi /etc/pam.d/system-auth 
vi /etc/pam.d/sudo
vi /etc/pam.d/passwd
chmod 600 /etc/sssd/sssd.conf 
systemctl start sssd
systemctl enable sssd
```
