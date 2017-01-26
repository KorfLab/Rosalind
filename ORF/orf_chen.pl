#!/usr/bin/perl
# orf_chen.pl by chen
use strict; use warnings;

die "usage: perl orf_chen.pl <file>\n" unless @ARGV == 1;

my $protein;

while (<>) {
	if (/^>/) {
		next;
	} else {
		for (my $i = 0; $i < length($_); $i += 3) {
			$protein .= codon2protein(substr($_, $i, 3));
		}
	}	
}
my $protein_M = substr($protein, "M");
for (my $i = 0; $i < length($protein); $i++) {
	my $orf = substr($protein_M, "b");
	print "$orf\n";
}


sub codon2protein {
	my $code = shift @_;
	my %genetic_code = (
	        UUU => 'F',
        	CUU => 'L',      
		AUU => 'I',
        	GUU => 'V',
        	UUC => 'F',
        	CUC => 'L',
        	AUC => 'I',
        	GUC => 'V',
        	UUA => 'L',
        	CUA => 'L',
        	AUA => 'I',
        	GUA => 'V',
        	UUG => 'L',  
        	CUG => 'L',
        	AUG => 'M',
        	GUG => 'V',
        	UCU => 'S',
        	CCU => 'P',
        	ACU => 'T',
        	GCU => 'A',
        	UCC => 'S',
        	CCC => 'P',
        	ACC => 'T',
       		GCC => 'A',
        	UCA => 'S', 
        	CCA => 'P',
        	ACA => 'T',
        	GCA => 'A',
        	UCG => 'S',
        	CCG => 'P',
        	ACG => 'T', 
        	GCG => 'A',
        	UAU => 'Y',  
        	CAU => 'H',
        	AAU => 'N',   
        	GAU => 'D',
        	UAC => 'Y',
        	CAC => 'H',   
       		AAC => 'N',
        	GAC => 'D',
       		UAA => 'b',
        	CAA => 'Q',
        	AAA => 'K',
        	GAA => 'E',
         	UAG => 'b',
		UGA => 'b',
        	CAG => 'Q',
        	AAG => 'K',     
        	GAG => 'E',
        	UGU => 'C',   
        	CGU => 'R',
        	AGU => 'S',   
        	GGU => 'G',
        	UGC => 'C',
        	CGC => 'R',
        	AGC => 'S',
        	GGC => 'G',
        	CGA => 'R',
        	AGA => 'R', 
        	GGA => 'G',
        	UGG => 'W',
        	CGG => 'R',
        	AGG => 'R',
        	GGG => 'G',
	);			    
return ($genetic_code{$code});
}

