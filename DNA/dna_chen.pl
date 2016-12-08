#!/usr/bin/perl
use strict;
use warnings;

die "usage: $0 <file>\n" unless @ARGV == 1;

my $countA;
my $countG;
my $countC;
my $countT;

while (<>) {
  $countA += tr/A/A/;
  $countC += tr/C/C/;
  $countG += tr/G/G/;
  $countT += tr/T/T/;
}

print "$countA $countC $countG $countT\n";
