#!/usr/bin/perl
use strict;

# Set the path to where we can find all block devices.  I tried just reading "/sys/block",
# but it didn't list all the block devices (oddly enough).
use constant PART_FILE => "/proc/partitions";

# Print the initial JSON object strings
print "{\n";
print "\t\"data\":[\n";

# Read PART_FILE to retrieve all partitions
open(FILE, PART_FILE);
my @partList=<FILE>;
close(FILE);
my $partCount=scalar(@partList);

# Loop through all block devices and print them as a JSON object
for(my $i=0; $i<$partCount; $i++){
        my $curLine=$partList[$i];

        # Skip any lines that don't appear to have a partition on them
        if(!($curLine =~ m/(\s*\d+\s*)+(.+)$/)){
			next;
        }
		my $device=$2;
		
		print "\t\t{\n";
		print "\t\t\t\"{#BDNAME}\":\"".$device."\"}";
		
		# Finish off the JSON object if this is the last line
		if($i == $partCount-1){
			print "]}\n";
		}
		else{
			print ",\n";
		}
		
}