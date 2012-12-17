#!/usr/bin/perl

# This takes one argument: a file name (can be full path to filename).
# It uses File::stat to pull the mtime from the file, and calculate the 
# difference between "now" and the mtime on the file. 
#
# Useful if you're worried about files being "touched" in a timeframe

use File::stat;

$filestats = stat(@ARGV[0]);
$filestamp = $filestats->mtime;
$now = time();
$difference = $now - $filestamp;
printf "%s\n", $difference;

