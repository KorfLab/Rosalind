#!/usr/bin/perl
#Rosalind_dna.pl by Kat
#Rosalind DNA Challenge
use warnings; use strict;


die "usage: ros_dna.pl <dna str>\n" unless @ARGV == 1;

#variable to hold
my $dna = $ARGV[0];

#nucleotide counters, initialize to zero
my ($a, $g, $t, $c) = (0, 0, 0, 0);
$a = ($dna =~ tr/Aa/Aa/);
$g = ($dna =~ tr/Gg/Gg/);
$t = ($dna =~ tr/Tt/Tt/);
$c = ($dna =~ tr/Cc/Cc/);
print "A C G T: $a $c $g $t\n";


