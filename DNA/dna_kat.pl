#!/usr/bin/perl
#dna_kat.pl by Kat
#Rosalind DNA Challenge
use warnings; use strict;


die "usage: dna_kat.pl <dna str>\n" unless @ARGV == 1;

#variable to hold
my $dna = $ARGV[0];

my $a = ($dna =~ tr/Aa/Aa/);
my $g = ($dna =~ tr/Gg/Gg/);
my $t = ($dna =~ tr/Tt/Tt/);
my $c = ($dna =~ tr/Cc/Cc/);
print "$a $c $g $t\n";
