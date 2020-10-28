# JellyfinSSL-Script
This script is there to help you setup https for Jellyfin.

You need to have a valid domain that is routing request to the IP with your jellyfin server for this to work.

If you want to use Apache instead of nginx, then do the same process below however,
With the ssl-apache.sh instead of ssl-nginx.sh

NB: In order for this to work you need to have access to port fowarding on your router.

SETUP For nginx:
````bash
git clone https://github.com/PineApple-Logic/JellyfinSSL-Script.git
cd JellyfinSSL-Script/
chmod +x ssl-nginx.sh
./ssl-nginx.sh
````

SETUP For apache:
````bash
git clone https://github.com/PineApple-Logic/JellyfinSSL-Script.git
cd JellyfinSSL-Script/
chmod +x ssl-apache.sh
./ssl-apache.sh
````

Done
