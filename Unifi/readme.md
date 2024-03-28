# HitronCodaWebUI.md 
Steps/command to add an IP to your WAN interface to access Hitron Coda56 Web interface from behind a Unifi NAT router.  
Likely will work on other routers as well. 

# SuperEasyMode.sh

This script adds an IP to your WAN interface on a unifi router to access the Hitron Coda56 webui from the NAT side of the router.

- Script finds your external IP address with curl and [ifconfig.me](https://ifconfig.me).
- Script then identifies the interface name with that IP. 
- Script then adds the NEW_IP to that interface.   
- Script then checks for the NEW_IP on the interface.

This script assumes you have your SSH pubkey on your unifi router for passwordless login.  
It will still work but you will have to enter the root password of the router a few times each time you run it.   
If you already have your sshkey pairs use ssh-copy-id to get it on your router.  
ex: `ssh-copy-id -i /home/bob/.ssh/id_rsa.pub root@192.168.1.1`  

Sshkey may not likely to survive a router firmware update, appears to survie a reboot. 
The added IP will not persist after a reboot.

Tested on Unif OS 3.2.12  

## Warning: the script has no error checking or state checking. Also it is ugly.

# SuperEasierMode.sh

Same function/purpose as SuperEasyMode.sh but better. 

Checks for existance of the new IP, if not found it adds it, then verifies if it was added. 


