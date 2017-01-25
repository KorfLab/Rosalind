#!/usr/bin/perl
# prtm_joy.pl
use strict;
use warnings;

die "usage: prtm_joy.pl <protein sequence file>\n" if @ARGV == 0;

my $protein;
while (<>) {
	chomp;
	$protein .= $_;
}

die "no input" unless $protein; 

my %AA_weight = (
	'A' =>   71.03711, 
	'C' =>   103.00919,
	'D' =>   115.02694,
	'E' =>   129.04259,
	'F' =>   147.06841,
	'G'	=>   57.02146,
	'H' =>   137.05891,
	'I' =>   113.08406,
	'K' =>   128.09496,
	'L' =>   113.08406,
	'M' =>   131.04049,
	'N' =>   114.04293,
	'P' =>   97.05276,
	'Q' =>   128.05858,
	'R' =>   156.10111,
	'S' =>   87.03203,
	'T' =>   101.04768,
	'V' =>   99.06841,
	'W' =>   186.07931,
	'Y' =>   163.06333, 
);

my $protein_weight;

for (my $i = 0; $i < length($protein); $i++) {
	my $aa = substr($protein, $i, 1);
	$protein_weight += $AA_weight{$aa};
}
printf "%.3f\n", $protein_weight;

