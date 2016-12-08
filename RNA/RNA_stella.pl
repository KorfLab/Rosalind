#!/usr/bin/perl

use strict; use warnings;

my ($input1) = @ARGV;

die "usage: $0 <file input>\n" unless @ARGV;

open (my $in1, "<", $input1) or die "Cannot read from $input1: $!\n";
while (my $line = <$in1>) {
	chomp($line);
	$line =~ tr/T/U/;
	print "$line\n";	
}
close $in1;
