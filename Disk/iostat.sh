#!/bin/bash

# This is very rough and could use some adaptation.  This was specific to a particular environment, 
# so all of the disk labels are specific.  There's probably a better way to do this, but
# I haven't taken the time to reason out what it is.

if [ "$OSTYPE" = "SunOS" ]; then

   #     device    name of the disk
   #
   #     r/s       reads per second
   #
   #     w/s       writes per second
   #
   #     kr/s      kilobytes read per second
   #
   #               The average I/O size during the  interval  can  be
   #               computed from kr/s divided by r/s.
   #
   #     kw/s      kilobytes written per second
   #
   #               The average I/O size during the  interval  can  be
   #               computed from kw/s divided by w/s.
   #
   #     wait      average number of transactions waiting for service
   #               (queue length)
   #
   #               This is the number of I/O operations held  in  the
   #               device  driver queue waiting for acceptance by the
   #               device.
   #
   #     actv      average number of transactions actively being ser-
   #               viced  (removed  from  the  queue but not yet com-
   #               pleted)
   #
   #               This is the number of I/O operations accepted, but
   #               not yet serviced, by the device.
   #
   #     svc_t     average response time  of  transactions,  in  mil-
   #               liseconds
   #
   #               The svc_t  output  reports  the  overall  response
   #               time,  rather  than the service time, of a device.
   #               The overall time includes the time  that  transac-
   #               tions  are in queue and the time that transactions
   #               are being serviced. The time  spent  in  queue  is
   #               shown  with  the  -x  option  in the wsvc_t output
   #               column. The time spent servicing  transactions  is
   #               the  true service time. Service time is also shown
   #               with the -x option and appears in the asvc_t  out-
   #               put column of the same report.
   #
   #     %w        percent of time there are transactions waiting for
   #               service (queue non-empty)
   #
   #     %b        percent of time the disk is busy (transactions  in
   #               progress)
   #
   #     wsvc_t    average  service  time  in  wait  queue,  in  mil-
   #               liseconds
   #
   #     asvc_t    average service time of  active  transactions,  in
   #               milliseconds
   #
   #     wt        the I/O wait time is no  longer  calculated  as  a
   #               percentage  of  CPU  time, and this statistic will
   #               always return zero.
   
   # Columns
   #      1      2      3      4    5    6      7      8   9  10     11
   # $ iostat -xn $(grep ufs /etc/vfstab | awk '{print $1}' | awk -F\/ '{print $4}' | sed -e 's#s0$##') 1 2
   #                    extended device statistics              
   #    r/s    w/s   kr/s   kw/s wait actv wsvc_t asvc_t  %w  %b device
   #    0.0    0.0    0.0    0.0  0.0  0.0    0.0    0.0   0   0 c1t0d0
   
   STUB=$(iostat -xn `grep ufs /etc/vfstab | awk '{print $1}' | awk -F\/ '{print $4}' | sed -e 's#s0$##'` 1 2 | head -1)
   
   case "$1" in 
      "reads-sec"	) echo $STUB | awk '{print $1}'  ;;
      "writes-sec"	) echo $STUB | awk '{print $2}'  ;;
      "kbread-sec"	) echo $STUB | awk '{print $3}'  ;;
      "kbwrite-sec"	) echo $STUB | awk '{print $4}'  ;;
      "wait"		) echo $STUB | awk '{print $5}'  ;;
      "actv"		) echo $STUB | awk '{print $6}'  ;;
      "wsvc_t"		) echo $STUB | awk '{print $7}'  ;;
      "asvc_t"		) echo $STUB | awk '{print $8}'  ;;
      "percent_wait"	) echo $STUB | awk '{print $9}'  ;;
      "percent_busy"	) echo $STUB | awk '{print $10}' ;;
      *			) echo "ZBX_NOTSUPPORTED"        ;;
   esac

elif [ "$OSTYPE" = "Linux" ]; then
   #              Device:
   #                     This column gives the device (or partition) name, which is displayed as hdiskn with 2.2 kernels, for  the
   #                     nth  device. It is displayed as devm-n with 2.4 kernels, where m is the major number of the device, and n
   #                     a distinctive number.  With newer kernels, the device name as listed in the /dev directory is  displayed.
   #
   #              tps
   #                     Indicate  the number of transfers per second that were issued to the device. A transfer is an I/O request
   #                     to the device. Multiple logical requests can be combined into a single  I/O  request  to  the  device.  A
   #                     transfer is of indeterminate size.
   #
   #              Blk_read/s
   #                     Indicate  the  amount of data read from the device expressed in a number of blocks per second. Blocks are
   #                     equivalent to sectors with 2.4 kernels and newer and therefore have a size of 512 bytes. With older  ker-
   #                     nels, a block is of indeterminate size.
   #
   #              Blk_wrtn/s
   #                     Indicate the amount of data written to the device expressed in a number of blocks per second.
   #
   #              Blk_read
   #                     The total number of blocks read.
   #
   #              Blk_wrtn
   #                     The total number of blocks written.
   #
   #              kB_read/s
   #                     Indicate the amount of data read from the device expressed in kilobytes per second.
   #
   #              kB_wrtn/s
   #                     Indicate the amount of data written to the device expressed in kilobytes per second.
   #
   #              kB_read
   #                     The total number of kilobytes read.
   #
   #              kB_wrtn
   #                     The total number of kilobytes written.
   #
   #              MB_read/s
   #                     Indicate the amount of data read from the device expressed in megabytes per second.
   #
   #              MB_wrtn/s
   #                     Indicate the amount of data written to the device expressed in megabytes per second.
   #
   #              MB_read
   #                     The total number of megabytes read.
   #
   #              MB_wrtn
   #                     The total number of megabytes written.
   #
   #              rrqm/s
   #                     The number of read requests merged per second that were queued to the device.
   #
   #              wrqm/s
   #                     The number of write requests merged per second that were queued to the device.
   #
   #              r/s
   #                     The number of read requests that were issued to the device per second.
   #
   #              w/s
   #                     The number of write requests that were issued to the device per second.
   #
   #              rsec/s
   #                     The number of sectors read from the device per second.
   #
   #              wsec/s
   #                     The number of sectors written to the device per second.
   #
   #              rkB/s
   #                     The number of kilobytes read from the device per second.
   #
   #              wkB/s
   #                     The number of kilobytes written to the device per second.
   #
   #              rMB/s
   #                     The number of megabytes read from the device per second.
   #
   #              wMB/s
   #                     The number of megabytes written to the device per second.
   #
   #              avgrq-sz
   #                     The average size (in sectors) of the requests that were issued to the device.
   #
   #              avgqu-sz
   #                     The average queue length of the requests that were issued to the device.
   #
   #              await
   #                     The  average time (in milliseconds) for I/O requests issued to the device to be served. This includes the
   #                     time spent by the requests in queue and the time spent servicing them.
   #
   #              svctm
   #                     The average service time (in milliseconds) for I/O requests that were issued to the device.
   #
   #              %util
   #                     Percentage of CPU time during which I/O requests were issued to the device (bandwidth utilization for the
   #                     device). Device saturation occurs when this value is close to 100%.
   #
   #              ops/s
   #                     Indicate the number of operations that were issued to the mount point per second
   #
   #              rops/s
   #                     Indicate the number of read operations that were issued to the mount point per second
   #
   #              wops/s
   #                     Indicate the number of write operations that were issued to the mount point per second
   
   # aaronm@rh001 (03:45 PM) [~] $ iostat -xkd cciss/c0d0p2 1
   # Linux 2.6.18-194.8.1.el5 (rh001) 	03/15/2011
   # 
   # Columns
   #                    1        2      3      4      5        6      7         8        9      10     11
   # Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
   # cciss/c0d0p2 
   #                   5.79   407.18  0.54 216.18   44.65  2389.68    22.47     0.48    2.20   0.52  11.19

   PRIMARY_DEV=$(iostat | head -7 | head -1 | awk '{print $1}')
   STUB=$(iostat -xkd ${PRIMARY_DEV} 1 2 | head -2 | head -1)

   case "$1" in
      "rrqm-sec"        ) echo $STUB | awk '{print $1}'  ;;
      "wrqm-sec"        ) echo $STUB | awk '{print $2}'  ;;
      "reads-sec"       ) echo $STUB | awk '{print $3}'  ;;
      "writes-sec"      ) echo $STUB | awk '{print $4}'  ;;
      "kbread-sec"      ) echo $STUB | awk '{print $5}'  ;;
      "kbwrite-sec"     ) echo $STUB | awk '{print $6}'  ;;
      "avgrq-sz"        ) echo $STUB | awk '{print $7}'  ;;
      "avgqu-sz"        ) echo $STUB | awk '{print $8}'  ;;
      "await"           ) echo $STUB | awk '{print $9}'  ;;
      "svctm"           ) echo $STUB | awk '{print $10}' ;;
      "percent_util"    ) echo $STUB | awk '{print $11}' ;;
      *			) echo "ZBX_NOTSUPPORTED"           ;;
   esac

else
   echo "ZBX_NOTSUPPORTED"
fi
