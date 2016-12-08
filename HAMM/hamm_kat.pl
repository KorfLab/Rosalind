#!usr/bin/perl
#hamm_kat.pl by Kat
use warnings; use strict;

die "usage: hamm_kat.pl <dna seq1> <dna seq2> returns Hamming distance\n"
	unless @ARGV == 2;
	
#strings to hold seq1 and seq2
my ($dna1, $dna2) = @ARGV;

#arrays to hold nucleotides
my @dna1 = split("", $dna1);
my @dna2 = split("", $dna2);

#compare elements, count differences (minimum point mutations)
my $hamming = 0;

for(my $i = 0; $i < scalar(@dna1); $i++)
{
	if($dna1[$i] eq $dna2[$i]){}
	else{ $hamming++; }
}

print $hamming, "\n";