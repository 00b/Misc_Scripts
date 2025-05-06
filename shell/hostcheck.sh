!/bin/sh
#Simple host checking script. 
#./hostcheck.sh <hostname.fqdn or ipaddress>
# Does DNS lookup on target host. 
# Checks for some open ports. 
#I use it to quickly figure out if a host is up and what the OS is likely to be and or role of the system based on ports.

TEST_PORTS=(22 80 443 3389)
TEST_TIMEOUT=5

#if [ uname if [[ "$(uname -s)" == "Linux" ]];
case "$(uname -s)" in
  Linux)
    #echo "This is Linux."
    TIME_OUT_OPT="-w"
    ;;
  Darwin)
    #echo "This is macOS."
    TIME_OUT_OPT="-G"
    ;;
  *)
    echo "Unknown operating system."
    ;;
esac

#if no argument with host name or IP. prompt.
#if agrument is provided add tag from that.
if [ "$#" -ne 1 ]; then
    read -p "Please enter FQDN or IP of target to check: " TARGETSYS
else
    TARGETSYS=$1
fi

#Do a DNS lookup. 
host $TARGETSYS

#Test all TEST_PORTS
for PORT in ${TEST_PORTS[@]};
        do
                nc -zv $TARGETSYS $PORT $TIME_OUT_OPT $TEST_TIMEOUT
        done
