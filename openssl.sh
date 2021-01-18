#!/bin/bash

#Pre-setup
clear

#If we already know the location what is the point of 'which' can't we just use -f
#in the [], meaning if exists

#nginx=$(which nginx)
#if [$nginx = '/usr/bin/nginx']
#apache=$(which apache)
#if [$nginx = '/usr/bin/nginx']


echo '1.Apache or 2.Nginx'
echo
read -p 'Enter a Number:' num
if [ $num = 1 ]
  then
    ser=apache
  else
   if [ $num = 2 ]
    then
      ser=nginx
    else
      clear
      echo 'Error invalid number.'
      sleep 2s
      ./openssl.sh
    fi
 fi
echo
read -p 'Email address:' Email
echo
read -p 'Domain:' Domain
clear

#Installing requirments
declare -A osinfo;
osinfo[/etc/redhat-release]=yum
osinfo[/etc/arch-release]=pacman
osinfo[/etc/gentoo-release]=emerge
osinfo[/etc/SuSE-release]=zypp
osinfo[/etc/debian_version]=apt
for f in ${!osInfo[@]}
do
    if [ -f /bin/${!osInfo[$f]} ]
    then
        pman=${osInfo[$f]}
    else
      clear
      echo
      echo 'Failed to identify your Package Manager'
      echo 'Please Enter it below'
      echo
      read -p 'Package Manager:' pman
    fi
done
echo 'Installing certbot'
sudo $pman install certbot python3-certbot-$ser
if [ -f /usr/bin/certbot && -f /usr/bin/python3-certbot-$ser ]
  then
    clear
  else
    echo
    echo 'Failed to install cerbot'
    echo "Try to install certbot and phython3-cerbot-$ser manually"
    echo
    exit
fi

#Port Forward
echo 'Port forward 80 to 80 and 443 to 443'
echo '(Must be done to pass the cert challenge)'
echo
read -p 'Press enter to continue'
clear

#Get Certs
sudo certbot --$ser --agree-tos --redirect --hsts --staple-ocsp --email $Email -d $Domain --rsa-key-size 4096
clear
if [ -e /etc/letsencrypt/live/$Domain/cert.pem ]
  then
    echo
    echo 'Certificate successfully created'
    echo
    sleep 1s
  else
    echo 'Failed to create certificate.'
    echo
    echo 'Troubleshoot list:'
    echo '1. Check for miss entries on the router'
    echo "2. Make sure $ser is running on port 80 (netstat -tulpn) else"
    echo    'change the LAN port forwarding on the router to the port it is running on'
fi
echo 'Please enter a directory path where you want to save your certificate'
echo '(Jellyfin must have access to this directory)'
echo
read -p 'Directory:' path

#Patch for Jellyfin
clear
sudo openssl pkcs12 -export -out jellyfin.pfx -inkey /etc/letsencrypt/live/$Domain/privkey.pem -in /etc/letsencrypt/live/$Domain/cert.pem -passout pass:
sudo mv jellyfin.pfx $path
sudo chown jellyfin:jellyfin $path/jellyfin.pfx
if sudo [ -e $path/jellyfin.pfx ]
  then
    echo
    echo 'Jellyfin cert patch successfully'
    echo
  else
    echo
    echo 'Failed to patch certificate for Jellyfin.'
    exit
fi

echo "0 0 * * 1 root certbot renew --quiet --no-self-upgrade --post-hook 'systemctl reload $ser'" | sudo tee -a /etc/cron.d/renew_certbot
echo "0 0 * * 1 root openssl pkcs12 -export -out /etc/letsencrypt/live/$Domain/jellyfin.pfx -inkey /etc/letsencrypt/live/$Domain/privkey.pem -in /etc/letsencrypt/live/$Domain/cert.pem -passout pass:" | sudo tee -a /etc/cron.d/renew_certbot
echo "0 0 * * 1 cp /etc/letsencrypt/live/$Domain/jellyfin.pfx $path/jellyfin.pfx" | sudo tee -a /etc/cron.d/renew_certbot
echo "0 0 * * 1 root chown jellyfin:jellyfin $path/jellyfin.pfx" | sudo tee -a /etc/cron.d/renew_certbot
echo "0 0 * * 1 root systemctl restart jellyfin.service" | sudo tee -a /etc/cron.d/renew_certbot

if [ -f  /etc/cron.d/renew_certbot ]
  then
    clear
  else
    echo
    echo 'Failed to create automated certificate renewal'
    echo
    read -p 'Press Enter if you wish to leave it and continue'
    clear

#Reboot
echo
echo '1. Add the jellyfin.pfx file to your SSL cert path in jellyfin,'
echo   'also finish all other requirments in jelyfin Network https'
echo
echo '2. Change port forwarding to 8096 to 80 and 8920 to 443'
echo
echo '3. Restart Jellyfin'
echo
exit
