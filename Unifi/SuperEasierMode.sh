#!/bin/bash
#
#Script to add a secondary IP to the WAN interface on a Ubquiti Unifi Dream Machine.
#Script created to be able to reach Coda56 cable modem WebUI at 192.168.100.1.
#Script might have additional uses, may work on other devices. Only tested on Unif OS 3.2.12.  
#
#IP will not survive a reboot. If you need that there are better packages/tools.
#infact you might be better off using those...
#No warranty. Mileage may varry. etc.
#

TARGET_ROUTER="192.168.1.1"
TARGET_USER="root"
NEW_IP="192.168.100.2" #NEW IP
NEW_IP_CIDR="30" #NEW IP CIDR MASK


find_interface () {
	MATCHING_INTERFACE=`ssh $TARGET_USER@$TARGET_ROUTER ip addr | awk -vtarget_addr=$1 '
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
	if [ -z "$MATCHING_INTERFACE" ]
	then
		echo ""
	else
		echo "$MATCHING_INTERFACE"
		#return $MATCHING_INTERFACE
	fi
}

echo "Getting external IP"
EXT_IP=`curl ifconfig.me`
echo "External IP: $EXT_IP"
echo "Finding external IP interface name on router"


TARGET_INTERFACE="$(find_interface $EXT_IP)"
if [ -z "$TARGET_INTERFACE" ]
then
	echo "nope"
else
	echo "found interface $TARGET_INTERFACE"
fi


CHECK="$(find_interface $NEW_IP)"
if [ -z "$CHECK" ]
then
	echo "Adding $NEW_IP/$NEW_IP_CIDR to $TARGET_INTERFACE"
	ssh $TARGET_USER@$TARGET_ROUTER ip addr add $NEW_IP/$NEW_IP_CIDR dev $TARGET_INTERFACE
	RECHECK="$(find_interface $NEW_IP)"
	if [ -z "RECHECK" ]
	then
		echo "nope"
		return 2
	else
		echo "Found $NEW_IP on interface $TARGET_INTERFACE"
	fi
else
	echo "Found $NEW_IP on interface $TARGET_INTERFACE"
fi
