# Access Hitron Coda56 Cable Modem WebUI from Unifi NAT

Hitron cable modems with firmware 7.3.5.0.1b2 or higher have a webui. 
To access the webui you must have a system on the same network. 
[Hitron article](https://us.hitrontech.com/knowledge-base/how-do-i-access-the-gui-on-the-coda56/) with details. 

Instructions: 
1. login via debug on web console or ssh. 
2. Issue command `ip addr add 192.168.100.2/30 dev eth8`
3. ~~Profit~~ Done.

You should now be able to access https://192.168.100.1 on your Hitron Coda56. 

- Tested on Dream Machine Pro SE.
- Setting will be lost on router reboots. 
- Adjust interface as needed if not using the standard WAN port. 
- Command is likely to work on other/similar router platforms as well.


No warranty blah blah. 
