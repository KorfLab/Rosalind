#!/usr/bin/perl
# fib_joy.pl
use strict;
use warnings;
use integer;

die "usage: fib_joy.pl <input file with n and k>\n" if @ARGV == 0;

my ($n, $k);
while (<>) {
	chomp;
	($n, $k) = split;
}

my @fib;
$fib[0] = 1; $fib[1] = 1;
for (my $i = 2; $i < $n; $i++) {
	$fib[$i] = $fib[$i - 2] * $k + $fib[$i - 1];
}
print pop(@fib), "\n";