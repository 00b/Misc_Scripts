The netbox way of updating netbox is a bit painful for me. So I wrote a bash script to it for me. So far its saved me TENS of minutes, not quite enough to cover the time to write the script but one or two more upgrades and I think it will be at the break even or net time savings point. 

Use at your own risk, not responsible for data loss or problems caused by it etc etc. Be sure to snapshot your VM and or make a backup of your database, configs, etc. 


to use it:
1. download it.
2. make it executable. `chmod +x netbox-upgrader.sh`
3. run it `sudo ./netbox-upgrader.sh <X.X.X>`


If you are making a large enough version leap you may need to do an upgrade to an intermediate version or two due to various schemea and other changes. Read release notes to figure out of that is necessary first. 
