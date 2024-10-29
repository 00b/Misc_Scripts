#!/bin/bash
#put version number in the parameter and script downloads tar.gz version. 
#sudo ./netbox-doupdate.sh 3.4.9

#Writen 9/30/2024
#Author Ben Clark

#downloads the version entered when run. 
#extracts to /opt/netbox-<version>
#copies config from active copy. 
#replaces symbolic link to /opt/netbox with new version
#runs netbox upgrade script /opt/netbox/upgrade.sh

if [ "$EUID" -ne 0 ]
  then echo "Please run as root or with sudo!"
  exit
fi

if [ "$#" -ne 1 ]; then
    echo "Invalid number of parameters. Need the version number."
    echo "sudo $0 <version number>"
    #echo "sudo $0 4.1.3" 
    exit
fi

#Download the specified version
echo "downloading netbox version $1" 
wget https://github.com/netbox-community/netbox/archive/refs/tags/v$1.tar.gz

#Mostly copied and pasted from upgrade guide with minor modifications. 
#https://netboxlabs.com/docs/netbox/en/stable/installation/upgrading/
#Changed sequence to copy from /opt/netbox to /opt/netbox-<newversion>
#vs their copy from /opt/netbox-<oldversion> to /opt/netbox to simplify this 
#script by not needing to write more logic/code to figure get old version numbers etc. 
#Moved creation of symbolic link to last before running the upgrade script

#Extract the downloaded version to /opt/netbox-<version>
echo "extracting v$1.tar.gz to /opt/"
tar -xzf v$1.tar.gz -C /opt

#Copy config files
echo "copying /opt/netbox/local_requirements.txt to /opt/netbox-$1"
cp /opt/netbox/local_requirements.txt /opt/netbox-$1
echo "copying /opt/netbox/netbox/netbox/configuration to /opt/netbox-$1/netbox/netbox/"
cp /opt/netbox/netbox/netbox/configuration.py /opt/netbox-$1/netbox/netbox/
echo "copying /opt/netbox/netbox/netbox/ldap_config.py to /opt/netbox-v$1/netbox/netbox/"
cp /opt/netbox/netbox/netbox/ldap_config.py /opt/netbox-$1/netbox/netbox/
echo "copying /opt/netbox/gunicorn.py to /opt/netbox-$1"
cp /opt/netbox/gunicorn.py /opt/netbox-$1/

#Copy media
echo "copying /opt/netbox/netbox/media to /opt/netbox-$1/netbox/netbox/"
cp -pr /opt/netbox/netbox/media/ /opt/netbox-$1/netbox/

#Copy scripts and reports
cp -r /opt/netbox/netbox/scripts /opt/netbox-$1/netbox/
cp -r /opt/netbox/netbox/reports /opt/netbox-$1/netbox/

#Upgrade starts here
#replace symbolic link to /opt/netbox with net version
ln -sfn /opt/netbox-$1 /opt/netbox

#run upgrade script
cd /opt/netbox/
./upgrade.sh

#restart service
systemctl restart netbox netbox-rq

if [ -f "/etc/cron.daily/netbox-housekeeping" ]; then
  echo "daily housekeeping cron file present. yay."
else
  echo "daily housekeeping cron File /etc/cron.daily/netbox-housekeeping does not exist."
  echo "creating symbolic link for it now. running 'ln -s /opt/netbox/contrib/netbox-housekeeping.sh /etc/cron.daily/netbox-housekeeping'"
  ln -s /opt/netbox/contrib/netbox-housekeeping.sh /etc/cron.daily/netbox-housekeeping
fi
