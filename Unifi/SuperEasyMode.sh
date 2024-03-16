#!/bin/bash
#This script adds an IP to your WAN interface on a unifi router. 

#Script finds your external IP address, then identifies the interface with that IP. 
#Script then adds the NEW_IP to that interface. 
#Warning: the script has no error checking or state checking.

#This script assumes you have your SSH pubkey on your unifi router for passwordless login.
#It will still work but you will have to enter the root password of the router a few times. 
#If you already have your ssh key pairs use ssh-copy-id to get it on your router. 
#ex: ssh-copy-id -i /home/bob/.ssh/id_rsa.pub root@192.168.1.1
#may not survive a firmware update or a reboot. 
#tested on Unif OS 3.2.12


TARGET_ROUTER="192.168.1.1"
TARGET_USER="root"
NEW_IP="192.168.100.2/30"

echo "Getting external IP"
EXT_IP=`curl ifconfig.me > `
echo $EXT_IP
echo "Finding external IP interface name on router"
TARGET_INTERFACE=`ssh $TARGET_USER@$TARGET_ROUTER ip addr | awk -vtarget_addr=$EXT_IP '
/^[0-9]+/ {
  iface=substr($2, 0, length($2))
}

$1 == "inet" {
  split($2, addr, "/")
  if (addr[1] == target_addr) {
    print iface
  }
}
'`

echo $TARGET_INTERFACE
echo "Adding $NEW_IP to $TARGET_INTERFACE"
ssh $TARGET_USER@$TARGET_ROUTER ip addr add $NEW_IP dev $TARGET_INTERFACE
echo "Verifying router has $NEW_IP"
NEW_IP_INTERFACE=`ssh $TARGET_USER@$TARGET_ROUTER ip addr | awk -vtarget_addr=$EXT_IP '
/^[0-9]+/ {
  iface=substr($2, 0, length($2))
}

$1 == "inet" {
  split($2, addr, "/")
  if (addr[1] == target_addr) {
    print iface
  }
}
'`
echo "$NEW_IP found on $NEW_IP_INTERFACE"
