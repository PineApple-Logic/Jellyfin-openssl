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
read
clear

#Get Certs
sudo certbot --nginx --agree-tos --redirect --hsts --staple-ocsp --email $Email -d $Domain --rsa-key-size 4096
echo 'Enter cert.pem path'
read path

#Patch for Jellyfin
clear
cd $path
openssl pkcs12 -export -out jellyfin.pfx -inkey privkey.pem -in $path/cert.pem -passout pass:
mkdir ~/Documents/openssl
sudo mv jellyfin.pfx ~/Documents/openssl
cd ~/Documents/openssl
sudo chowm jellyfin:jellyfin jellyfin.pfx

#Check
echo.
echo ------------------------------------------------------------------------
echo 'Check for errors. if any error are found cancle (ctrl +c ) and report'
echo ------------------------------------------------------------------------
echo.
echo press enter to continue
read
echo "0 0 * * *  root  certbot renew --quiet --no-self-upgrade --post-hook 'systemctl reload nginx'" | sudo tee -a /etc/cron.d/renew_certbot

#Reboot
clear
echo.
echo '1.Add the jellyfin.pfx file to your SSL cert path in jellyfin'
echo    'also finish all other requirmentsin jelyfin Network https'
echo.
echo '2.change port forwarding to 8096 to 80 and 8920 to 443'
echo.
echo '3.Reboot'
echo press enter to continue
read
