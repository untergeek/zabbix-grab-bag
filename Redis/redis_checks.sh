#!/bin/bash

# PIDFILE could be autodiscovered, as could REDISLOG if an anticipated path to the redis.conf were known.
# This script presupposes that the redis binary is run by a redis user.
#
# Note: This script also depends on the filetime.pl in this repo to determine the age of the redis log file.

PIDFILE=""
REDISLOG=""
PATH=$PATH:/usr/local/bin

case "$1" in
   "running"       ) if [ -e "$PIDFILE" ]; then
			ps auwwx | grep $(cat $PIDFILE) | grep -c ^redis
		     else
			echo 0
		     fi ;;
   "buffer_size"   ) tail -20 $REDISLOG | grep "bytes in use" | tail -1 | awk '{print $11}' ;;
   "queue"	   ) ### Check queue depth 
			if [ "x$3" = "x" ]; then
			   redis-cli LLEN $2 | sed -e 's#(integer)\ ##'
			else
			   redis-cli -n $3 LLEN $2 | sed -e 's#(integer)\ ##'
                        fi
                        ;;
   "client_count"  ) tail -20 $REDISLOG | grep "bytes in use" | tail -1 | awk '{print $6}' ;;
   "logfile_age"   ) /home/zabbix/bin/filetime.pl $REDISLOG ;;
   *     	   ) echo "ZBX_NOTSUPPORTED"        ;;
esac
