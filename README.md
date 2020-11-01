# JellyfinSSL-Script
This script is there to help you setup https for Jellyfin.

**Requirements**
1. In order for this to work you need to have access to port fowarding on your router.

2. You also need to have a valid domain that is routing request to your public IP, of the decive jellyfin server is running on.
   We recommended [DuckDNS](https://duckdns.org) to setup one, if you don't already have one.

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
