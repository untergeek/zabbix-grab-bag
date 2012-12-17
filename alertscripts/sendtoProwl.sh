#!/bin/bash

# This is a wrapper I wrote to prowl.pl
# Author: Aaron Mildenstein

### Call prowl.pl
#Usage:
#    prowl.pl [options] event_information
#
#     Options:
#       -help              Display all help information.
#       -apikey=...        Your Prowl API key.
#       -apikeyfile=...    A file containing your Prowl API key.
#
#     Event information:
#       -application=...   The name of the application.
#       -event=...         The name of the event.
#       -notification=...  The text of the notification.
#       -priority=...      The priority of the notification.
#                          An integer in the range [-2, 2].

# PROWLPATH is the path to the prowl.pl script provided by http://prowlapp.com
PROWLPATH=/home/zabbix/server/bin

APPLICATION="ZabbixProwl"
APIKEY=$1
EVENT=$2
NOTIFICATION=$3
ZBX_NOTIF_LOG=/var/log/zabbix_notif.log
DATE=$(date +%s)

# If you have a line in your notification with an "Acknowledge http://www.example.com/zabbix/acknow.php?..."
# this will assign the URL appropriately, otherwise, no URL.
URL="-url=$(echo $NOTIFICATION | grep Acknowledge | awk '{print $2}')"
if [ "$(echo $URL | grep -c http)" -lt "1" ]; then
   URL=" "
fi

### PRIORITY 
#
# Establish Priority based on the subject string (In our case $2, EVENT)

#### Default value of 0 if not provided. An integer value ranging [-2, 2] representing:
#### -2 Very Low
#### -1 Moderate
####  0 Normal
####  1 High
####  2 Emergency
####
#### Emergency priority messages may bypass quiet hours according to the user's settings.

# Our Map:
#### -2 Information
#### -1 Warning
####  0 Average
####  1 High
####  2 Disaster
####

HEADER=$(echo $EVENT | awk -F: '{print $1}')

PRIORITY=0

case "$HEADER" in

"Info"|"Information"|"Recovery"|"RECOVERY"	) PRIORITY=-2 ;;
"Warning"|"WARNING"		 		) PRIORITY=-1 ;;
"Problem"|"PROBLEM"|"Average"|"AVERAGE"		) PRIORITY=0 ;;
"High"|"HIGH" 					) PRIORITY=1 ;;
"Disaster"|"DISASTER"|"Emergency"|"EMERGENCY"	) PRIORITY=2 ;;
esac

echo "${DATE}|PROWL|${1}|${2}" >> ${ZBX_NOTIF_LOG}

${PROWLPATH}/prowl.pl -apikey=${APIKEY} -application="${APPLICATION}" -event="${EVENT}" -notification="${NOTIFICATION}" -priority=${PRIORITY} ${URL}
