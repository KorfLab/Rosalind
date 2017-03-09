#!/usr/bin/perl
use strict;
use warnings;

my $sum;
while (<>) {
	for (my $i =0; $i < length($_); $i++) {
		$sum += ord(substr($_, 0, 1));
	}
}

print $sum % 256, "\n";
