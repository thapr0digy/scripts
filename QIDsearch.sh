#!/bin/bash
#
# This will search for QIDs and output nicely.
#
##############################################

NARGS="$#"

# Check for arguments
OPTS=$(getopt -o dhsq --long "date:,help,sid:,qid:"  -- "$@")
eval set -- "$OPTS"
while true
do
        case "$1" in
                -d) date=$2; shift 2;;
                -h) helps=1; shift;;
                -s) sid=$2; shift 2;;
                -q) qid=$2; shift 2;;
                --date) date=$2; shift 2;;
                --sid) sid=$2; shift 2;;
                --qid) qid=$2; shift 2;;
                --) shift; break;;
        esac
done

# Set logging


