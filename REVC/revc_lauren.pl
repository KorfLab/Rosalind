#!/usr/bin/perl
#revc.pl - ROSALIND
use strict; use warnings; 

die "usage: rev.pl <dna sequence>\n" unless @ARGV == 1;

my $dna = uc($ARGV[0]);
$dna =~ tr/ACTG/TGAC/;
my $rev = reverse $dna; {print "$rev\n";}
