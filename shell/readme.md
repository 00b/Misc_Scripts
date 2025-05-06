# Simple host checking script. 

Super simple script to get some quick info about a hostname or IP. I use it to quickly figure out if a host is up and what the OS is likely to be and or role of the system based on ports.
Works on mac and linux and adjusts the nc command based on OS its running on.

usage: `./hostcheck.sh <hostname.fqdn or ipaddress>`  
Does DNS lookup on target host.  
Checks for some open ports.  
