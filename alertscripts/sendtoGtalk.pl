#!/usr/bin/perl -w

# Adapted slightly to log the transaction to a logfile
# author: Aaron Mildenstein

#
# script to send jabber message to Google Talk Instant Messaging
#   using XMPP protocol and SASL PLAIN authentication.
#
# author: Thus0 <Thus0@free.fr>
# Copyright (c) 2005, Thus0 <thus0@free.fr>. All rights reserved.
#
# released under the terms of the GNU General Public License v2

use strict;
use Net::XMPP;

# GoogleTalk username of "FROM" user
my $username = "";
my $password = "";

my $logfile = "/var/log/zabbix_notif.log";
my $timestamp = time();

system `echo "$timestamp|GTALK|$ARGV[0]|$ARGV[1]" >> $logfile`;


## Configuration
## 3 Arguments will be passed. 
## $ARGV[0] username (Google Talk username minus the @gmail.com part)
## $ARGV[1] Subject
## $ARGV[2] Message

my $to = "$ARGV[0]";
my $body = "$ARGV[1]\n\n$ARGV[2]\n";

my $resource = "ZabbixGTalk";

## End of configuration

#------------------------------------

# Google Talk & Jabber parameters :

my $hostname = 'talk.google.com';
my $port = 5222;
my $componentname = 'gmail.com';
my $connectiontype = 'tcpip';
my $tls = 1;

#------------------------------------

my $Connection = new Net::XMPP::Client();

# Connect to talk.google.com
my $status = $Connection->Connect(
       hostname => $hostname, port => $port,
       componentname => $componentname,
       connectiontype => $connectiontype, tls => $tls);

if (!(defined($status))) {
   print "ERROR:  XMPP connection failed.\n";
   print "        ($!)\n";
   exit(0);
}

# Change hostname
my $sid = $Connection->{SESSION}->{id};
$Connection->{STREAM}->{SIDS}->{$sid}->{hostname} = $componentname;

# Authenticate
my @result = $Connection->AuthSend(
       username => $username, password => $password,
       resource => $resource);

if ($result[0] ne "ok") {
   print "ERROR: Authorization failed: $result[0] - $result[1]\n";
   exit(0);
}

# Send message
$Connection->MessageSend(
       to => "$to\@$componentname", body => $body,
       resource => $resource);
