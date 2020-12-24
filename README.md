# JellyfinSSL-Script
This script is there to help you setup https for Jellyfin.
This script only work on linux (for now) a windows version is being worked on.
The script also adds a task to automatically renewal the certificates.

### **Requirements** ###
1. In order for this to work you need to have access to port fowarding on your router.

2. You also need to have a domain name. We recommend [DuckDNS](https://duckdns.org) to setup one, if you don't already have one.

### SETUP For Nginx: ####
````bash
git clone https://github.com/PineApple-Logic/JellyfinSSL-Script.git
cd JellyfinSSL-Script/
chmod +x ssl-nginx.sh
./ssl-nginx.sh
````

### OR ###

### SETUP For Apache: ###
````bash
git clone https://github.com/PineApple-Logic/JellyfinSSL-Script.git
cd JellyfinSSL-Script/
chmod +x ssl-apache.sh
./ssl-apache.sh
````

Done
