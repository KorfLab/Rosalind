#!/usr/bin/perl
# HAMM_joy.pl
use strict;
use warnings;

die "usage: HAMM_joy.pl <DNA input file in Download folder>
  file should contain two lines, where each line is a DNA sequence\n" unless @ARGV == 1;

my @seq;

open(my $in, "</Users/s130963/Downloads/$ARGV[0]") or die "error reading $ARGV[0]";
while (<$in>) {
	chomp;
	push(@seq, $_);
}
close $in;

die "incorrect number of lines in the input file\n" unless @seq == 2;

my $l;
$l = (length($seq[0]) >= length($seq[1]) ? 0 : 1);

my $count = abs(length($seq[0]) - length($seq[1]));

for (my $i = 0; $i < (length($seq[abs($l-1)])); $i++) {
	my $s = substr($seq[$l], $i, 1);
	my $t = substr($seq[abs($l-1)], $i, 1) ;
	if ($s !~ m/$t/) {$count++}
}
print "$count\n";
