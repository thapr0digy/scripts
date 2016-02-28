#!/bin/bash

# Set default variables
size=50
NARGS="$#"

# Check for arguments
OPTS=$(getopt -o hms --long "help,memory,swap,size:"  -- "$@")
eval set -- "$OPTS"
while true
  do
    case "$1" in
      -h) helps=1; shift;;
      -m) mem=1; shift;;
      -s) swap=1; shift;;
      --help) helps=1; shift;;
      --memory) mem=1; shift;;
      --swap) swap=1; shift;;
      --size) size=$2; shift 2;;
      --) shift; break;;
    esac
done   

# Set logging directories
logdir=/var/log/sysstat
output=/tmp/highmem.log

# Function definitions
usage () {

  fold -s -w $(tput cols) << EOF

  This script will check for specific values for memory/swap.

  Usage: $0 [-h|--help]

  Options:

  -h    --help  Display this help text
  -m    --mem   Check for memory values higher than --size (Default: 50)
  -s    --swap  Check for swap values higher than --size (Default: 50)

EOF
exit 0

}

memorySearch () {

  echo -e "Looking for high memory usage within sar file\n"
  for i in {1..31} 

  do 

    if [ -e "$logdir/sa$i" ]; then
        sar -r -f $logdir/sa$i | sed 's/ PM/PM/g' | head -n -1 | awk 'NR == 5 {print} $4 >= '$size' {print $0}' > $output.day$i
    fi
  
    if [ ! -s "$output.day$i" ]; then
        echo -e "Day $i has no matches"
    fi

  done

  echo -e "\nYou can find the log files in /tmp\n"
  exit 0
}

swapSearch () {

   echo -e "Looking for high swap usage within\n"    
   for i in {1..31}
               
   do
                 
     if [ -e "$logdir/sa$i" ]; then
         sar -S -f $logdir/sa$i | sed 's/ PM/PM/g' | head -n -1 | awk 'NR == 5 {print} $4 >= '$size' {print $0}' > $output.day$i
     fi  
                       
     if [ ! -s "$output.day$i" ]; then
         echo -e "Day $i has no matches\n"
     fi  
                           
   done
   
   echo -e "\nYou can find the log files in /tmp\n"
   exit 0
}

# Main function area
[ "$NARGS" = 0 ] && usage
[ "$helps" = 1 ] && usage
[ "$mem" = 1 ] && memorySearch
[ "$swap" = 1 ] && swapSearch 

exit 0
