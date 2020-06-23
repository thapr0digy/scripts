#!/bin/bash
## Default template 

# Help/Usage description
helps () {
fold -s -w $(tput cols) << EOF

This script will do stuff 

Usage

  $0 [-h|--help]

Options:

  -h   --help      	     	Display this help text.
  -u   --user=username       	Information related to user
  -i   --ip=ipaddress        	Information related to IP Address
  -l				Logins to the GUI
  -c   				Changes made in the GUI
  -s   --section=value		Anything related to the specific section
    				Possible values are: appliance,system,admin,reports,quarantine,users,enduser,ss,email,virus,spam,tap,dlp,encryption,regcomp,assets
  
  -d   				Digest generations
  -o   				Output file
  -f   				Format of the output (Default: txt) csv,txt

EOF
exit 0
}


## Environment stuff
## Arguments
OPTS=$(getopt -o huilcsdo --long "help,user:,ip:,section:"  -- "$@")
eval set -- "$OPTS"
while true
  do
    case "$1" in
      -h) helps; shift;;
      -u) user=$2; shift 2;;
      -i) ipaddr=$2; shift 2;;
      -l) logins=1; shift;;
      -c) changes=1; shift;;
      -s) section=$2; shift 2;;
      -d) digest=1; shift;;
      -o) output=$2; shift 2;;
      --help) helps; shift;;
      --user) user=$2; shift 2;;
      --ip) ipaddr=$2; shift 2;;
      --sections) section=$2; shift 2;;
      --) shift; break;;

    esac
done

## Logging
logfile=/tmp/${log}.log.$(date +%Y%m%d-%H%M%S)
errfile=/tmp/${log}.err.$(date +%Y%m%d-%H%M%S)
log_num=$(ls -1tr ${log}*[0-9]* 2>/dev/null | wc -l)
[ $log_num -gt $(($logroll * 2)) ] && ls -1tr ${log}*[0-9]* 2>/dev/null | head -n +$(($logroll * 2)) | xargs rm
for logf in $logfile $errfile
  do
    touch $logf
  done
[ -e ${log}.log ] && rm ${log}.log
ln $logfile ${log}.log
[ -e ${log}.err ] && rm ${log}.err
ln $errfile ${log}.err
[ $log_num -gt 2 ] && for oldlog in $(ls -1tr ${log}*[0-9]* 2>/dev/null | head -n-2 | grep -v ".gz$")
  do
    gzip $oldlog
  done
exec 2> >(tee -a ${log}.err)
exec > >(tee -a ${log}.log)

## Sanity checks
# contrary to popular belief, sanity checking is good
[ ${USER} != root ] && echo -e "\nError: please run this script as the 'root' user!\n" && exit 2
[ $NARGS -eq 0 ] && helps  

## Functions
# things and stuff!

## logic
# main
