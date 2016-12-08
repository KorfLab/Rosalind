#!/usr/bin/perl

use strict; use warnings;

my ($input1) = @ARGV;

die "usage: $0 <file input>\n" unless @ARGV;

open (my $in1, "<", $input1) or die "Cannot read from $input1: $!\n";
while (my $line = <$in1>) {
	chomp($line);
	my ($n, $k) = split(" ", $line);
	my $young0 = 1; 
	my $young1 = 0;
	my $adult = 0;
	for (my $month = 1; $month <= $n; $month++) {
		$adult += $young1;
		$young1 = $young0;
		$young0 = 0;
		my $pair = $adult + $young1 + $young0;
		$young0 = $adult * $k;
		#print "month $month, young0 $young0, young1 $young1, adult $adult, total $pair\n";
		print "$pair\n" if $month == $n;
	}
}
close $in1;
