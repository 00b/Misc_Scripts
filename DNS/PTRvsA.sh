# Uses host command verify ip address of the A record and PTR records are the same. 
# Used to catch PTR records that maybe out of date or incorrect. 
# Will return false mismatches due to cnames, multiple A records etc, also output sorta breaks.
#
# ./PTRvsA.sh 10.10.10.10

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

for x in `host -t PTR $1 | awk {'print $5'}`; do       
        hostip=`host -t A $x | awk {'print $4'}`
        #echo "PTR $1 -> $x -> $hostip"
        if [ "$hostip" = "$1" ]; then
                echo "PTR ${GREEN}matching ${NOCOLOR} $1 -> $x -> $hostip"
        else
                echo "PTR ${RED}mismatch ${NOCOLOR} $1 -> $x -> $hostip" 
        fi
done
