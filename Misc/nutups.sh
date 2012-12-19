#!/bin/bash

PATH=$PATH:/usr/local/bin
UPSNAME=cyberpower
UPSHOST=localhost

KEY=$1
VALUE=$(upsc ${UPSNAME}@${UPSHOST} | grep ${KEY}: | sed -e "s/${KEY}: //")
if [ "x${VALUE}" = "x" ]; then
   VALUE="ZBX_NOTSUPPORTED"
elif [ "${KEY}" = "ups.status" ]; then
   # There could be multiple values. Bitmapping is our friend
   RETVAL=0
   for STATUS in ${VALUE}; do
      case $STATUS in
  	'OL' ) RETVAL=$((RETVAL + 0)) ;; # On line (mains is present)
  	'OB' ) RETVAL=$((RETVAL + 1)) ;; # On battery (mains is not present)
  	'LB' ) RETVAL=$((RETVAL + 2)) ;; # Low battery
  	'RB' ) RETVAL=$((RETVAL + 4)) ;; # The battery needs to be replaced
	*    ) RETVAL=$((RETVAL + 0)) ;; # Ignore other statuses here
      esac
   done
   VALUE=$RETVAL
elif [ "${KEY}" = "ups.test.result" ]; then
   case $VALUE in
      "Done and passed"		) VALUE=0 ;;
      "Test scheduled"		) VALUE=1 ;;
      "Scheduled" 		) VALUE=1 ;;
      "In progress"		) VALUE=2 ;;
      "No test initiated"	) VALUE=3 ;;
      "Inhibited" 		) VALUE=4 ;;
      "Aborted"			) VALUE=5 ;;
      "Done and warning"	) VALUE=6 ;;
      "Done and error"		) VALUE=7 ;;
      *				) VALUE=8 ;;
   esac

fi

echo ${VALUE}

# Key						Value			Units
#battery.charge					 100 			%	
#battery.charge.low				 10			%
#battery.charge.warning				 20			%
#battery.mfr.date				 CPS
#battery.runtime				 1144			s
#battery.runtime.low				 300			s
#battery.type					 PbAcid
#battery.voltage				 13.9			volts
#battery.voltage.nominal			 12			volts
#device.mfr					 CPS
#device.model					  CP 1350C
#device.type					 ups
#driver.name					 usbhid-ups
#driver.parameter.pollfreq			 30			s
#driver.parameter.pollinterval			 2			s
#driver.parameter.port				 /dev/ugen1.2
#driver.parameter.vendorid			 0764
#driver.version					 2.6.5
#driver.version.data				 CyberPower HID 0.3
#driver.version.internal			 0.37
#input.transfer.high				 140			volts
#input.transfer.low				 90			volts
#input.voltage					 122.0			volts
#input.voltage.nominal				 120			volts
#output.voltage					 121.0			volts
#ups.beeper.status				 enabled
#ups.delay.shutdown				 20			s
#ups.delay.start				 30			s
#ups.load					 28			%
#ups.mfr					 CPS
#ups.model					  CP 1350C
#ups.productid					 0501
#ups.realpower.nominal				 298			watts
#ups.status					 OL			(value map: OL = 0, OB = 1, LB = 2)
#ups.test.result				 Done and passed
#ups.timer.shutdown				 -60			s
#ups.timer.start				 0			s
#ups.vendorid					 0764


