#!/usr/bin/perl
#rna.pl - ROSALIND
use strict; use warnings;

die "usage: rna.pl <dna sequence>\n" unless @ARGV == 1;

my $dna = uc($ARGV[0]);  
$dna =~ s/T/U/g; {print "$dna\n";}

