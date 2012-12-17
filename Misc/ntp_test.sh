#!/bin/bash

# The path to ntpq is fixed here.  Could be discovered, I suppose.
# The path to awk is also fixed.

# This script was adapted to work in a Solaris Zone (e.g., no local ntpd as it runs in the global zone),
# hence the returned value in such a case is deliberately fixed below my threshold to prevent 
# false positives.

TEST=$(/usr/sbin/ntpq -pn 2>&1 | grep -c "Connection refused")
if [ "$TEST" -gt "0" ]; then
   RETURN=4.99;
else
   RETURN=$(/usr/sbin/ntpq -pn | /usr/bin/awk 'BEGIN { offset=1000 } $1 ~ /\*/ { offset=$9 } END { print offset }')
fi

echo $RETURN
