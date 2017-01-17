#!/usr/bin/perl
# iprb_joy.pl
use strict;
use warnings;

die "usage: iprb_joy.pl <input file with k, m and n>\n" if @ARGV == 0;

my ($k, $m, $n);
while (<>) {
	chomp;
	($k, $m, $n) = split;
}

my $prob_rec = (( 0.25 * $m * ($m - 1)) + ($m * $n) + ($n * ($n - 1)))/
				(($k + $m + $n) * ($k + $m + $n - 1));
my $prob_dom = 1 - $prob_rec;
printf "%.5f\n", $prob_dom; 