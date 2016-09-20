#!/bin/sh
# Username and password are for any CTS login linked to the company's account
USERNAME="31e002dd-b4d5-4b9a-941f-75c5c1851ede"
PASSWORD="f91e2dae023cb788ec0d9f7f5c7c588510c90847b7a1dc209a12a7c605702b54"
# Alert to and from addresses are use to notify administrators when failures occur during log retrieval
ALERTTOADDRESS=""
ALERTFROMADDRESS="noreply@proofpoint.com"
# Determines where log file are downloaded. Defaults to the current directory.
LOGDIR=`pwd`
# Include Campaign information
CAMPINFO="no"
# Get the options
OPTS=`getopt -o c:ht: --long "help"  -- "$@"`
eval set -- "$OPTS"
while true
    do
      case "$1" in
              -h|--help) usage; shift;;
              -c) CAMPAIGNID=$2; shift 2;;
              -t) THREATID=$2; shift 2;;
              --) shift; break;;
      esac
done

echo "CAMPAIGNID: $CAMPAIGNID"
echo "THREATID: $THREATID"
# Determines the amount of data retrieved the first time the script is run. Uses ISO8601 format - PT1H specifies the previous
# hour's worth of data, PT10M specifies the previous 10 minutes. No more than two hours can be specified.
LOGFILESUFFIX="forensics.log"
ERRORFILESUFFIX="forensics.error"
TMPFILESUFFIX="forensics.tmp"

# Set the timing for logging
INTERVAL=`date`
INTERVAL_SECS=`date -d "$INTERVAL" +%s`
INTERVAL_ISO=`date -d "$INTERVAL" +%Y-%m-%dT%H:%M:%S%z`
#LASTINTERVAL=`cat $LASTINTERVALFILE`
#LASTINTERVAL_SECS=`date -d "$LASTINTERVAL" +%s`
#LASTINTERVAL_ISO=`date -d "$LASTINTERVAL" +%Y-%m-%dT%H:%M:%S%z`
#DIFF=`expr $INTERVAL_SECS - $LASTINTERVAL_SECS`

# Functions

usage() {
    echo "Usage: $0 -t <threatID> for threat information"
    echo "Usage: $0 -c <campaign ID>"
    exit 1
}

campaign() {
    echo "Retrieving data for $CAMPAIGNID"
    STATUS=$(curl -w '%{http_code}' -o "$LOGDIR/$INTERVAL_SECS-$CAMPAIGNID-$TMPFILESUFFIX" "https://tap-api-v2.proofpoint.com/v2/forensics?campaignId=$CAMPAIGNID" --user "$USERNAME:$PASSWORD" -s)
    if [ $? -eq 0 ] && [ $STATUS = "200" ]; then
      mv "$LOGDIR/$INTERVAL_SECS-$CAMPAIGNID-$TMPFILESUFFIX" "$LOGDIR/$INTERVAL_SECS-$CAMPAIGNID-$LOGFILESUFFIX"
      echo "Retrieval successful. $LOGDIR/$INTERVAL_SECS-$CAMPAIGNID-$LOGFILESUFFIX created."
      exit 0
    fi
    mv "$LOGDIR/$INTERVAL_SECS-$CAMPAIGNID-$TMPFILESUFFIX" "$LOGDIR/$INTERVAL_SECS-$CAMPAIGNID-$ERRORFILESUFFIX"
    echo "Retrieving TAP Forensics for $CAMPAIGNID failed with error code $STATUS. Error was: " && cat "$LOGDIR/$INTERVAL_SECS-$CAMPAIGNID-$ERRORFILESUFFIX"
    # | mailx -s 'Retrieving TAP SIEM logs failed!' -S "from=SIEM Retriever <$ALERTFROMADDRESS>" $ALERTTOADDRESS
    echo "Retrieval unsuccessful. Failed with error code $STATUS."
    exit 1
}

threat() {
  if [ $CAMPINFO = "yes" ]; then
    echo "Retrieving data for $THREATID and includeCampaignForensics"
    STATUS=$(curl -w '%{http_code}' -o "$LOGDIR/$INTERVAL_SECS-$THREATID-$TMPFILESUFFIX" "https://tap-api-v2.proofpoint.com/v2/forensics?threatId=$THREATID&includeCampaignForensics=true" --user "$USERNAME:$PASSWORD" -s)
  else
    echo "Retrieving data for $THREATID"
    STATUS=$(curl -w '%{http_code}' -o "$LOGDIR/$INTERVAL_SECS-$THREATID-$TMPFILESUFFIX" "https://tap-api-v2.proofpoint.com/v2/forensics?threatId=$THREATID" --user "$USERNAME:$PASSWORD" -s)
  fi
  
  # Check for the status and mv the temporary file to log file
  if [ $? -eq 0 ] && [ $STATUS = "200" ]; then
    mv "$LOGDIR/$INTERVAL_SECS-$THREATID-$TMPFILESUFFIX" "$LOGDIR/$INTERVAL_SECS-$THREATID-$LOGFILESUFFIX"
    echo "Retrieval successful. $LOGDIR/$INTERVAL_SECS-$THREATID-$LOGFILESUFFIX created."
    exit 0
  fi
  mv "$LOGDIR/$INTERVAL_SECS-$THREATID-$TMPFILESUFFIX" "$LOGDIR/$INTERVAL_SECS-$THREATID-$ERRORFILESUFFIX"
  echo "Retrieving TAP Forensics for $THREATID failed with error code $STATUS. Error was: " && cat "$LOGDIR/$INTERVAL_SECS-$THREATID-$ERRORFILESUFFIX"
  # | mailx -s 'Retrieving TAP SIEM logs failed!' -S "from=SIEM Retriever <$ALERTFROMADDRESS>" $ALERTTOADDRESS
  echo "Retrieval unsuccessful. Failed with error code $STATUS."
  exit 1
}

# Print help if there aren't any arguments
# [ test case ] && function
[ -n "$CAMPAIGNID" ] && campaign;
[ -n "$THREATID" ] && threat;