#!/usr/bin/perl
# prot_joy.pl
use strict;
use warnings;

die "usage: prot_joy.pl <mRNA>\n" if @ARGV == 0;

my $rna;
while (<>) {
	chomp;
	$rna .= $_;
}

die "no input" unless $rna; 

my %AA = (
	'UUU' => 'F',      'CUU' => 'L',      'AUU' => 'I',      'GUU' => 'V',
	'UUC' => 'F',      'CUC' => 'L',      'AUC' => 'I',      'GUC' => 'V',
	'UUA' => 'L',      'CUA' => 'L',      'AUA' => 'I',      'GUA' => 'V',
	'UUG' => 'L',      'CUG' => 'L',      'AUG' => 'M',      'GUG' => 'V',
	'UCU' => 'S',      'CCU' => 'P',      'ACU' => 'T',      'GCU' => 'A',
	'UCC' => 'S',      'CCC' => 'P',      'ACC' => 'T',      'GCC' => 'A',
	'UCA' => 'S',      'CCA' => 'P',      'ACA' => 'T',      'GCA' => 'A',
	'UCG' => 'S',      'CCG' => 'P',      'ACG' => 'T',      'GCG' => 'A',
	'UAU' => 'Y',      'CAU' => 'H',      'AAU' => 'N',      'GAU' => 'D',
	'UAC' => 'Y',      'CAC' => 'H',      'AAC' => 'N',      'GAC' => 'D',
	'UAA' => ' ',      'CAA' => 'Q',      'AAA' => 'K',      'GAA' => 'E',
	'UAG' => ' ',      'CAG' => 'Q',      'AAG' => 'K',      'GAG' => 'E',
	'UGU' => 'C',      'CGU' => 'R',      'AGU' => 'S',      'GGU' => 'G',
	'UGC' => 'C',      'CGC' => 'R',      'AGC' => 'S',      'GGC' => 'G',
	'UGA' => ' ', 	   'CGA' => 'R',      'AGA' => 'R',      'GGA' => 'G',
	'UGG' => 'W',      'CGG' => 'R',      'AGG' => 'R',      'GGG' => 'G', 
);

my @aa_seq;

for (my $i = 0; $i < (length($rna) - 3); $i++) {

	# search for start codon
	my $start = substr($rna, $i, 3);
	if ($start eq 'AUG') {
	
		# translation
		for (my $j = $i; $j < length($rna) - 3; $j+= 3) {
			my $codon = substr($rna, $j, 3);
			if ($AA{$codon} eq ' ') { last } # exist loop at stop codon
			else 			   		{ push (@aa_seq, $AA{$codon}) }				
		}
		last; # terminate loop once start is found
	}
}
print @aa_seq, "\n";

