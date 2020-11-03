#!/bin/bash

#Install requirments
sudo apt install certbot python3-certbot-nginx
clear

#Pre-setup
echo 'Email address'
read Email
clear
echo 'Domain'
read Domain
clear

#Port Forward
echo 'Port forward 80 to 80 and 443 to 443'
echo '(Must be done to pass the cert challenge)'
echo
echo 'Press enter to continue'
read
clear

#Get Certs
sudo certbot --nginx --agree-tos --redirect --hsts --staple-ocsp --email $Email -d $Domain --rsa-key-size 4096
echo 'Enter cert.pem directory path'
read path

#Patch for Jellyfin
clear
sudo openssl pkcs12 -export -out jellyfin.pfx -inkey $path/privkey.pem -in $path/cert.pem -passout pass:
mkdir ~/openssl
sudo mv jellyfin.pfx ~/openssl
cd ~/openssl
sudo chown jellyfin:jellyfin jellyfin.pfx

#Check
echo
echo ----------------------------------------------------------------
echo 'Check for errors. If any errors are found, cancel (ctrl + c ) and report'
echo ----------------------------------------------------------------
echo
echo 'Press enter to continue'
read
echo "0 0 * * *  root  certbot renew --quiet --no-self-upgrade --post-hook 'systemctl reload nginx'" | sudo tee -a /etc/cron.d/renew_certbot

#Reboot
clear
echo
echo '1. Add the jellyfin.pfx file to your SSL cert path in jellyfin'
echo   'also finish all other requirmentsin in jelyfin Network https'
echo
echo '2. Change port forwarding to 8096 to 80 and 8920 to 443'
echo
echo '3. Reboot'
echo
echo 'Press enter to continue'
read
