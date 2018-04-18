while true; do
    read -p 'username? > ' username
    if [ "$username" == "" ]; then
        continue
    else
        break
    fi
done
read -p 'setup LDAP? [y/N] > ' setup_ldap
if [ "$setup_ldap" == "Y" -o "$setup_ldap" == "y" ]; then
    pacman -S sssd unzip
    curl -o etc.zip https://github.com/iTakeshi/dotfiles/raw/master/arch/ldap/etc.zip
    unzip etc.zip
    cp etc/sssd/sssd.conf    /etc/sssd/sssd.conf
    cp etc/nscd.conf         /etc/nscd.conf
    cp etc/nsswitch.conf     /etc/nsswitch.conf
    cp etc/pam.d/system-auth /etc/pam.d/system-auth
    cp etc/pam.d/sudo        /etc/pam.d/sudo
    cp etc/pam.d/passwd      /etc/pam.d/passwd
    chmod 600 /etc/sssd/sssd.conf
    echo -n 'Now, edit ldap_uri and ldap_search_base in sssd.conf. Press enter to open vi.'
    read
    vi /etc/sssd/sssd.conf
    systemctl start sssd
    systemctl enable sssd

    while true; do
        read -p 'group name? > ' usergroup
        if [ "$usergroup" == "" ]; then
            continue
        else
            break
        fi
    done
    mkdir /home/$username
    chown $username:$usergroup /home/$username
    gpasswd -a $username wheel
else
    useradd -m -G wheel $username
    passwd $username
fi

curl -o /home/$username/setup-user.sh https://raw.githubusercontent.com/iTakeshi/dotfiles/master/arch/setup-user.sh
chown $username /home/$username/setup-user.sh
