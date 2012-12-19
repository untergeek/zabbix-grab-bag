#!/bin/bash

# Author: Aaron Mildenstein
#
# This script presumes redis is running locally.
#
# You can extract a list of potential values by running:
# redis-cli INFO
# 
# This is by no means an exhaustive list.  It could be extended to report pubsub or other statistics.
# Just fill in the gaps.

PIDFILE=/var/run/redis/redis.pid
PATH=/opt/zabbix/bin:$PATH:/usr/local/bin

# $1 = Zabbix "key," or the redis INFO key whose value we want
# $2 = Redis list or pubsub key
# $3 = Redis db number

# We need at least one arg
if [ "x$1" = "x" ]; then 
   exit 1
fi

# If no DB number is provided, presume 0
if [ "x$3" = "x" ]; then 
   DB=0
else
   DB=$3
fi

case "$1" in
  "running"   	) if [ -e "${PIDFILE}" ]; then
			RESULT=$(ps auwwx | grep $(cat ${PIDFILE}) | grep -c redis-server)
	          else
			RESULT=0
	  	  fi 
		  ;;
  "list_length"	) # We need a second arg here:
		  if [ "x$2" = "x" ]; then
		     exit 1
                  else
		     RESULT=$(redis-cli -n ${DB} LLEN ${2} | sed -e 's#(integer)\ ##') 
		  fi 
		  ;;
  *		) RESULT=$(redis-cli -n ${DB} INFO | grep ${1}: | awk -F: '{print $2}') ;;
esac

if [ "x${RESULT}" = "x" ]; then
   echo "ZBX_NOTSUPPORTED"
else
   echo ${RESULT}
fi
