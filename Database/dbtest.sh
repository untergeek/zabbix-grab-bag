#!/bin/bash

# This is a simple Oracle database test script that will connect to SID with USERNAME & PASSWORD and time how long a simple query will take.
# The query provided is "select * from dual", but you can put whatever you want here.

SID=""
USERNAME=""
PASSWORD=""

# Source your own oracle environment here:
. /opt/oracle/product/11.2/oracle.env

export ORACLE_SID="${SID}"

execute_query ()
{
   local query=$(sqlplus -S ${USERNAME}/${PASSWORD}@${ORACLE_SID} << EOF
   set pagesize 0
   set linesize 80
   set heading off
   set feedback off
   set tab off
   set define off
   ${1};
   quit
   EOF)
#   echo $query
   return
}

QUERY="select * from dual"


## Main

START_TIME=$(date +%s.%N)
execute_query "${QUERY}"
END_TIME=$(date +%s.%N)

ELAPSED=$(printf "%.3F"  $(echo "$END_TIME - $START_TIME"|bc))

echo $ELAPSED
