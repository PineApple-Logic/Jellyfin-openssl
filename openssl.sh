#!/bin/bash

#Pre-setup
echo '1.Apache or 2.Nginx'
echo
read -p 'Enter a Number:' num
if [ $num = 1 ]
  then
    ser=apache
  else
   ser=nginx
fi
read -p 'Email address:' Email
echo
read -p 'Domain:' Domain
clear

#Install requirments
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        pman=${osInfo[$f]}
    fi
done
sudo $pman install certbot python3-certbot-$ser
sleep 1s
clear

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
    echo "Certificate successfully created"
    echo
    sleep 2s
  else
    echo "Failed to create certificate."
    echo "Troubleshoot list:"
    echo "1. Check for miss entries on the router"
    echo "2. Make sure $ser is running on port 80 (netstat -tulpn) else"
    echo    "change it on the router to the port it is running on"
    sleep 2s
    read
    exit
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
    echo "Jellyfin cert patch successfully"
    echo
  else
    echo
    echo "Failed to patch certificate for Jellyfin."
   sleep 2s
    echo
    echo "Press enter to exit"
    read
    exit
fi

#Automated renewal
echo "0 0 1 */2 *  root  certbot renew --quiet --no-self-upgrade --post-hook 'systemctl reload $ser'" | sudo tee -a /etc/cron.d/renew_certbot
echo "1 0 1 */2 * sudo openssl pkcs12 -export -out /etc/letsencrypt/live/$Domain/jellyfin.pfx -inkey /etc/letsencrypt/live/$Domain/privkey.pem -in /etc/letsencrypt/live/$Domain/cert.pem -passout pass:" | sudo tee -a /etc/cron.d/renew_certbot
echo "2 0 1 */2 * cp /etc/letsencrypt/live/$Domain/jellyfin.pfx $path/jellyfin.pfx" | sudo tee -a /etc/cron.d/renew_certbot
echo "3 0 1 */2 * sudo chown jellyfin:jellyfin $path/jellyfin.pfx" | sudo tee -a /etc/cron.d/renew_certbot
echo "4 0 1 */2 *  sudo systemctl restart jellyfin.service" | sudo tee -a /etc/cron.d/renew_certbot

#Reboot
clear
echo
echo '1. Add the jellyfin.pfx file to your SSL cert path in jellyfin,'
echo   'also finish all other requirments in jelyfin Network https'
echo
echo '2. Change port forwarding to 8096 to 80 and 8920 to 443'
echo
echo '3. Restart Jellyfin'
echo
echo 'Press enter to exit'
read
