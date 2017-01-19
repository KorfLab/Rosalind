#!/usr/bin/perl
# prot_chen.pl by chen
use strict; use warnings;

die "usage: perl prot_chen.pl <file> " unless @ARGV == 1;

my ($file) = @ARGV; #good practice. Never deal with ARGV more than once.

open (my $in, "<", $file) or die "Cannot read from $file: $!\n";
#file does not exist then $! will tell you "file does not exist"
#Cannot read from DNA.txt: File not found"
#Cannot read from DNA.txt: Perission denied"

#open IN,"<$ARGV[0]";
my $seq = <$in>;
my $protein = "";
for (my $i = 0; $i < length($seq); $i += 3) {
	$protein .= codon2protein(substr($seq, $i, 3));
}
print "$protein\n";
close $in;

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
        UAA => '',
        CAA => 'Q',
        AAA => 'K',
        GAA => 'E',
        UAG => '',
	UGA => '',
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
	return($genetic_code{$code});
}








