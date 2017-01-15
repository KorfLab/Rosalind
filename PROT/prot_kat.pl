#!/usr/bin/perl
#prot_kat.pl by kat
use warnings; use strict;


die "usage: prot_kat.pl <rna file> will display corresponding prot seq\n" unless @ARGV == 1;

open(IN, "<", $ARGV[0]);
my $rna;

#read in rna seq
while(<IN>)
{
	chomp;
	$rna .= $_;
}
close IN;

#print amino acid for each codon in rna seq
for(my $i = 0; $i < length($rna) -2; $i+=3)
{
	print codons_to_aa(substr($rna, $i, 3));
}
print "\n";

	
#subroutine codons_to_aa receives codon string and returns its amino acid from hash	
sub codons_to_aa
{
	my($cod) = @_;
	
	my %codons = (
		UUU => 'F',      CUU => 'L',      AUU => 'I',      GUU => 'V',
		UUC => 'F',      CUC => 'L',      AUC => 'I',      GUC => 'V',
		UUA => 'L',      CUA => 'L',      AUA => 'I',      GUA => 'V',
		UUG => 'L',      CUG => 'L',      AUG => 'M',      GUG => 'V',
		UCU => 'S',      CCU => 'P',      ACU => 'T',      GCU => 'A',
		UCC => 'S',      CCC => 'P',      ACC => 'T',      GCC => 'A',
		UCA => 'S',      CCA => 'P',      ACA => 'T',      GCA => 'A',
		UCG => 'S',      CCG => 'P',      ACG => 'T',      GCG => 'A',
		UAU => 'Y',      CAU => 'H',      AAU => 'N',      GAU => 'D',
		UAC => 'Y',      CAC => 'H',      AAC => 'N',      GAC => 'D',
		UAA => '',  	 CAA => 'Q',      AAA => 'K',      GAA => 'E',
		UAG => '',  	 CAG => 'Q',      AAG => 'K',      GAG => 'E',
		UGU => 'C',      CGU => 'R',      AGU => 'S',      GGU => 'G',
		UGC => 'C',      CGC => 'R',      AGC => 'S',      GGC => 'G',
		UGA => '', 		 CGA => 'R',      AGA => 'R',      GGA => 'G',
		UGG => 'W',      CGG => 'R',      AGG => 'R',      GGG => 'G', 
	);
	
	return $codons{$cod};
}



