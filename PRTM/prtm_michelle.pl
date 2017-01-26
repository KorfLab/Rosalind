#!/usr/bin/perl
# prtm_michelle.pl by michelle treiber
use strict;
use warnings;

# assigning weight to amino acids using a weighted amino acid alphabet 

die "usage: prot_michelle.pl <input amino acid sequence> \n" unless @ARGV == 1;

#open outside file
open (my $fh, "<$ARGV[0]") or die "Could not open input file, $ARGV[0]\n"; 
print "Input file: $ARGV[0]\n";
my $aa = <$fh>; #read file
chomp($aa);

my @split_str = split(//, $aa); #split peptide into single amino acids

# create hash to hold weight of each amino acid
my %alphabet_weight = (
	'A' => 71.03711,
	'C' => 103.00919,
	'D' => 115.02694,
	'E' => 129.04259,
	'F' => 147.06841,
	'G' => 57.02146,
	'H' => 137.05891,
	'I' => 113.08406,
	'K' => 128.09496,
	'L' => 113.08406,
	'M' => 131.04049,
	'N' => 114.04293,
	'P' => 97.05276,
	'Q' => 128.05858,
	'R' => 156.10111,
	'S' => 87.03203,
	'T' => 101.04768,
	'V' => 99.06841,
	'W' => 186.07931,
	'Y' => 163.06333, 
);

my $total = 0;
my $i = 0;
my ($key, $value); # declare variables from hash

#loop through hash, compare hash $key with $amino, if matched, add hash $value to $total
while($i < length($aa)) {
	while (($key, $value) = each(%alphabet_weight)) { 
		my $amino = $split_str[$i];
		if ($amino eq $key) {
			$total = $total + $value;
		}
	}
	$i = $i +1; #increment counter
}

print "$aa weight is $total\n";
close $fh;