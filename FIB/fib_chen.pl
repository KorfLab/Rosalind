#!/usr/bin/perl
# fib_chen.pl  by chen
use strict;  use warnings;

die "usage:perl fib_chen.pl <file>" unless @ARGV == 1;

open ($in,"<",$ARGV[0]);
my @array = split(" ", <$in>, 2);
my $A = 0;
my $B = 1;
my $C;

for (my $i = 1; $i < $array[0]; $i++) {
	$C = $B + $A * $array[1];
	$A = $B;
	$B = $C;
	}

print $C;
close $in;

