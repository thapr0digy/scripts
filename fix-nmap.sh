#!/bin/bash
date=`date +"%Y-%m-%d"`
backup_name="/usr/share/nmap/$date-nmap-service-probes"
echo "Backing up current nmap-service-probes to $backup_name"
sudo mv /usr/share/nmap/nmap-service-probes $backup_name
echo "Getting newest nmap-service-probes file"
sudo wget https://svn.nmap.org/nmap/nmap-service-probes -O /usr/share/nmap/nmap-service-probes
revision=`curl -s https://svn.nmap.org/nmap/ | grep -m 1 -oP '(?<=Revision )[0-9]+'`
id=`echo "nmap-service-probes $revision $date $USER"`
sudo sed -i "s/^\# \$Id.*/\# \$Id\$: $id/g" /usr/share/nmap/nmap-service-probes
