# HitronCodaWebUI.md 
Steps to access Hitron Coda56 Web interface from behind a unifi NAT 

# SuperEasyMode.sh
This script adds an IP to your WAN interface on a unifi router. 

- Script finds your external IP address with curl and ifconfig.me.
- Script then identifies the interface name with that IP. 
- Script then adds the NEW_IP to that interface.   


This script assumes you have your SSH pubkey on your unifi router for passwordless login.  
It will still work but you will have to enter the root password of the router a few times.   
If you already have your ssh key pairs use ssh-copy-id to get it on your router.   

ex: `ssh-copy-id -i /home/bob/.ssh/id_rsa.pub root@192.168.1.1`
sshkey may not survive a firmware update or a reboot. 

tested on Unif OS 3.2.12

## Warning: the script has no error checking or state checking. also it is ugly.
