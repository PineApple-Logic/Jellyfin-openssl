# JellyfinSSL-Script
This script is there to help you setup https for Jellyfin.

You need to have a valid domain that is routing request to the IP with your jellyfin server for this to work.

NB: In order for this to work you need to have access to port fowarding on your router.

SETUP For Nginx:
````bash
git clone https://github.com/PineApple-Logic/JellyfinSSL-Script.git
cd JellyfinSSL-Script/
chmod +x ssl-nginx.sh
./ssl-nginx.sh
````

SETUP For Apache:
````bash
git clone https://github.com/PineApple-Logic/JellyfinSSL-Script.git
cd JellyfinSSL-Script/
chmod +x ssl-apache.sh
./ssl-apache.sh
````

Done
