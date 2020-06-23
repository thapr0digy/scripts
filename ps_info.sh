#!/bin/bash
## Output ps aufx info into a log file 

## Sanity checks
# contrary to popular belief, sanity checking is good
[ ${USER} != root ] && echo -e "\nError: please run this script as the 'root' user!\n" && exit 2


## Logging
log=/var/log/ps_output
logroll=14
logfile=${log}.log
errfile=${log}.err.$(date +%Y%m%d-%H%M%S)
log_num=$(ls -1tr ${log}*[0-9]* 2>/dev/null | wc -l)


#[ $log_num -gt $(($logroll * 2)) ] && ls -1tr ${log}*[0-9]* 2>/dev/null | head -n +$(($logroll * 2)) | xargs rm
#for logf in $logfile $errfile
#  do
#    touch $logf
#  done
#[ -e ${log}.log ] && rm ${log}.log
#ln $logfile ${log}.log
#[ -e ${log}.err ] && rm ${log}.err
#ln $errfile ${log}.err
#[ $log_num -gt 2 ] && for oldlog in $(ls -1tr ${log}*[0-9]* 2>/dev/null | head -n-2 | grep -v ".gz$")
#  do
#    gzip $oldlog
#  done
#exec 2> >(tee -a ${log}.err)
#exec > >(tee -a ${log}.log)


## Functions
# things and stuff!

output() {
  date +%Y%m%d-%H%M%S 2>> $errfile 1>> $logfile
  ps aufx 2>> $errfile 1>> $logfile 
}

truncLogs() {
  [ 
  [ $log_num -gt $logroll ] && for oldlog

## logic
# main

[ $actsize -ge $msize ] && truncLogs
output
