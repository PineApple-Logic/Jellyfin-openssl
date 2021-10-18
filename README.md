# Jellyfin-openssl
This script is there to help you setup https for Jellyfin.
This script only work on linux (for now) a windows version is being worked on.

### **Requirements** ###
1. In order for this to work you need to have access to port fowarding on your router.

2. You also need to have a valid domain that is routing request to your public IP.
   We recommend [DuckDNS](https://duckdns.org) to setup one, if you don't already have one.

### SETUP: ####
````bash
git clone https://github.com/PineApple-Logic/JellyfinSSL-Script.git
cd JellyfinSSL-Script/
chmod +x openssl.sh
./openssl.sh
````
