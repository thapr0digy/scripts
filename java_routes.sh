#!/bin/bash
#eth=$(ip addr | egrep -v "\.0\.1/24" | grep -B2 "inet 10\\."| grep UP | egrep -o "eth.")
ppp=tun0
route add default gw $(ifconfig $ppp | grep 'inet 10' | awk '{print $2}') 
#sed -i.backup -e 's/search.*$/search us.proofpoint.com app.proofpoint.com corp.proofpoint.com spt.proofpoint.com proofpoint.com ppops.net/' /etc/resolv.conf
cp /etc/resolv.conf.proofpoint /etc/resolv.conf
