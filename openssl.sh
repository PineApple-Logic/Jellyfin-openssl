#!/bin/bash

#Pre-setup
echo '1.apache or 2.nginx'
read Number
1 = apache
2 = nginx
echo $Number
read
echo 'Email address'
read Email
clear
echo 'Domain'
read Domain
clear

#Install requirments
sudo apt install certbot python3-certbot-apache
clear

#Port Forward
echo 'Port forward 80 to 80 and 443 to 443'
echo '(Must be done to pass the cert challenge)'
echo
echo 'Press enter to continue'
read
clear

#Get Certs
sudo certbot --apache --agree-tos --redirect --hsts --staple-ocsp --email $Email -d $Domain --rsa-key-size 4096
clear
if [ -e /etc/letsencrypt/live/$Domain/cert.pem ]
  then
    echo
    echo "Certificate successfully created"
    echo
    sleep 2s
  else
    echo "Failed to create certificate."
    echo "Recommende checking for any miss entries on your router before trying again."
    sleep 2s
    read
    exit
fi
echo 'Please enter directory path where you want to save your certificate (Jellyfin must have access to this directory)'
read path

#Patch for Jellyfin
clear
sudo openssl pkcs12 -export -out jellyfin.pfx -inkey /etc/letsencrypt/live/$Domain/privkey.pem -in /etc/letsencrypt/live/$Domain/cert.pem -passout pass:
sudo cp jellyfin.pfx $path
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
echo "0 0 1 */2 *  root  certbot renew --quiet --no-self-upgrade --post-hook 'systemctl reload nginx'" | sudo tee -a /etc/cron.d/renew_certbot
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
