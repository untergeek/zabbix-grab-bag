#!/bin/bash 

GREPSTRING=$1
IP=$2
PORT=$3

JMXCLIENTJAR=/opt/zabbix/cmdline-jmxclient-0.10.3.jar
JSONHEADER='{\n\t"data":[\n'
JSONFOOTER='\t]\n}\n'
JSON=( )

### Discover what JMX stuff to send back

### Weird wrapping because of stupid subshell
LINES=$(java -jar ${JMXCLIENTJAR} - ${IP}:${PORT} | grep ${GREPSTRING} | sed -e 's/java.lang://' -e 's/name=//' | awk -F, '{print $1}' | \
while read LINE; do
  echo "$LINE" | sed -e 's# #SPACE#g'
done)

### Now that we have a series of lines, we'll act on them
for LINE in $(echo $LINES ); do
  FORMATTED_BEAN=$(printf "\\t\\t{\"{#JMXBEAN}\":\"$(echo $LINE | sed -e 's#SPACE# #g')\"}")
  JSON=("${JSON[@]}" "${FORMATTED_BEAN}")
done 

     
### Check to see if we have any results.  Proceed if so, exit with fail otherwise
if [ "${#JSON[@]}" -gt "0" ]; then
  ### Send values back
  printf "${JSONHEADER}\n"

  ### Loop through the array JSON appending commas after each line
  ### But DO NOT print the last line (${#JSON[@]} - 1) with a comma
  for ((idx=0;idx<$((${#JSON[@]} - 1));idx++)); do
    printf "${JSON[idx]},\n"
  done

  ### Print the last line now without a comma
  printf "${JSON[$((${#JSON[@]} - 1))]}\n"

  ### Print the footer
  printf "${JSONFOOTER}\n"
else
  echo "ZBX_NOTSUPPORTED"
fi
