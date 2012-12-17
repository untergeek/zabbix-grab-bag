#!/usr/bin/perl

# This is great to do a quick grab of apache stats.  This is called by the zext_apachestats script

use strict;
use warnings;
use Parse::Apache::ServerStatus;
    
# $ARGV[0] is the zabbix host name
# $ARGV[1] is the URL
my $zabbixHost = $ARGV[0];

$|++;
my $prs = Parse::Apache::ServerStatus->new(
    url => $ARGV[1],
    # url => 'http://localhost/server-status?auto',
    timeout => 10
);

my @order    = qw/p r i _ S R W K D C L G I . ta tt rs bs br/;
my $interval = 10;
my $header   = 20;

my $stat = $prs->get or die $prs->errstr;

# zabbix_sender file generation
   print  $zabbixHost, ":apache.stats.requests:", $stat->{r} , "\n";
   print  $zabbixHost, ":apache.stats.idle.workers:", $stat->{i} , "\n";
   print  $zabbixHost, ":apache.stats.waiting:", $stat->{_} , "\n";
   print  $zabbixHost, ":apache.stats.starting:", $stat->{S} , "\n";
   print  $zabbixHost, ":apache.stats.reading:" , $stat->{R} , "\n";
   print  $zabbixHost, ":apache.stats.sending.reply:" , $stat->{W} , "\n";
   print  $zabbixHost, ":apache.stats.keepalive:" , $stat->{K} , "\n";
   print  $zabbixHost, ":apache.stats.dns.lookup:" , $stat->{D} , "\n";
   print  $zabbixHost, ":apache.stats.closing:" , $stat->{C} , "\n";
   print  $zabbixHost, ":apache.stats.logging:" , $stat->{L} , "\n";
   print  $zabbixHost, ":apache.stats.graceful:" , $stat->{G} , "\n";
   print  $zabbixHost, ":apache.stats.idle.cleanup:" , $stat->{I} , "\n";
   print  $zabbixHost, ":apache.stats.open.process:" , $stat->{"."} , "\n";
   print  $zabbixHost, ":apache.stats.total.accesses:" , $stat->{ta} , "\n";
   print  $zabbixHost, ":apache.stats.total.traffic:" , $stat->{tt} , "\n";
   print  $zabbixHost, ":apache.stats.rps:" , $stat->{rs} , "\n";
   print  $zabbixHost, ":apache.stats.bps:" , $stat->{bs} , "\n";
   print  $zabbixHost, ":apache.stats.bpr:" , $stat->{br} , "\n";

#  Hash  Zabbix key     Description
#  ----  ----------     -----------
#    p    		Parents (this key will be kicked in future releases, dont use it)
#    r   requests 	Requests currenty being processed
#    i   idle.workers 	Idle workers
#    _   waiting 	Waiting for Connection
#    S   starting 	Starting up
#    R   reading 	Reading Request
#    W   sending.reply 	Sending Reply
#    K   keepalive 	Keepalive (read)
#    D   dns.lookup 	DNS Lookup
#    C   closing 	Closing connection
#    L   logging 	Logging
#    G   graceful 	Gracefully finishing
#    I   idle.cleanup 	Idle cleanup of worker
#    .   open.process 	Open slot with no current process
#
#    The following keys are set to 0 if extended server-status is not activated.
#
#    ta  total.accesses	Total accesses
#    tt  total.traffic 	Total traffic
#    rs  rps	 	Requests per second
#    bs  bps 		Bytes per second
#    br  bpr 		Bytes per request
