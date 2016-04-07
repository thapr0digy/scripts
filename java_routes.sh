#!/bin/bash
eth=$(ip addr | egrep -v "\.0\.1/24" | grep -B2 "inet 10\\."| grep UP | egrep -o "eth.")
ppp=tun0
route add default gw $(ifconfig $ppp | grep inet | awk '{print $3}' | cut -d: -f2)
#local subnet
route add -net 10.50.25.0/24 $eth
#printer slp-53
route add 10.50.4.202 $eth
#cisco webex
route add -net 64.68.96.0/19 $eth
#cisco webex
route add -net 66.114.160.0/20 $eth
#suth mail servers
route add -net 10.50.2.0/24 $eth
#suth gsd
route add -net 10.94.51.0/24 $eth
#suth helpdesk
route add -net 10.94.3.0/24 $eth
#suth sqms
route add -net 10.94.203.0/24 $eth
sed -i.backup -e 's/search.*$/search us.proofpoint.com app.proofpoint.com corp.proofpoint.com spt.proofpoint.com proofpoint.com ppops.net suth.com sutherlandglobal.com/' /etc/resolv.conf
