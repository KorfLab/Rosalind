#!/usr/bin/perl
#dna.pl - ROSALIND
use strict; use warnings; 

die "usage: dna.pl <dna sequence>\n" unless @ARGV == 1;

my ($seq) = uc($ARGV[0]);
my $a = ($seq =~ tr/A/A/);
my $c = ($seq =~ tr/C/C/);
my $g = ($seq =~ tr/G/G/);
my $t = ($seq =~ tr/T/T/);

print "$a $c $g $t\n";
