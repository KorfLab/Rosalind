#!/usr/bin/perl
#cons2_kat.pl by Kat
use warnings FATAL => 'all'; use strict;

my %codons_aa = (
	TTT => 'F',      CTT => 'L',      ATT => 'I',      GTT => 'V',
	TTC => 'F',      CTC => 'L',      ATC => 'I',      GTC => 'V',
	TTA => 'L',      CTA => 'L',      ATA => 'I',      GTA => 'V',
	TTG => 'L',      CTG => 'L',      ATG => 'M',      GTG => 'V',
	TCT => 'S',      CCT => 'P',      ACT => 'T',      GCT => 'A',
	TCC => 'S',      CCC => 'P',      ACC => 'T',      GCC => 'A',
	TCA => 'S',      CCA => 'P',      ACA => 'T',      GCA => 'A',
	TCG => 'S',      CCG => 'P',      ACG => 'T',      GCG => 'A',
	TAT => 'Y',      CAT => 'H',      AAT => 'N',      GAT => 'D',
	TAC => 'Y',      CAC => 'H',      AAC => 'N',      GAC => 'D',
	TAA => '',  	 CAA => 'Q',      AAA => 'K',      GAA => 'E',
	TAG => '',  	 CAG => 'Q',      AAG => 'K',      GAG => 'E',
	TGT => 'C',      CGT => 'R',      AGT => 'S',      GGT => 'G',
	TGC => 'C',      CGC => 'R',      AGC => 'S',      GGC => 'G',
	TGA => '', 		 CGA => 'R',      AGA => 'R',      GGA => 'G',
	TGG => 'W',      CGG => 'R',      AGG => 'R',      GGG => 'G', 
);

die "Usage: cub_kat.pl <dna fasta file> displays codon usage table\n"
 unless @ARGV == 1;

open(my $in, $ARGV[0]) or die "Error: failed to open $ARGV[0]\n";

my %cod_usage;
#Structure: {Amino Acid} : 	{CODON}	:---	{seq_id} => codon total for each seq		
#											{codon_total} => overall codon total
#						 : 	{aa_Total}

my $id;
my $seq = '';
my $first = 1;

while (<$in>)
{
	chomp;
	if($_ =~ m/^>(.+)/)
	{	
		if ($first)
		{			
			$first = 0;
		}
		else
		{
			for (my $i = 0; $i < length($seq) -2; $i+=3)
			{
				 $cod_usage{$codons_aa{substr($seq, $i, 3)}}{substr($seq, $i, 3)}{$id}++;
				 $cod_usage{$codons_aa{substr($seq, $i, 3)}}{substr($seq, $i, 3)}{cTOTAL}++;
			}
		}
		$id = $1;
		$seq = '';
	} 
	else
	{
		$seq .= $_
	}
}
for (my $i = 0; $i < length($seq) -2; $i+=3)
{
	 $cod_usage{$codons_aa{substr($seq, $i, 3)}}{substr($seq, $i, 3)}{$id}++;
	 $cod_usage{$codons_aa{substr($seq, $i, 3)}}{substr($seq, $i, 3)}{cTOTAL}++;
}
			
my $grand_tot = 0;
foreach my $aa (keys %cod_usage)
{
	foreach my $codon (keys %{$cod_usage{$aa}})
	{
		$grand_tot += $cod_usage{$aa}{$codon}{cTOTAL};
		$cod_usage{$aa}{aTOTAL} += $cod_usage{$aa}{$codon}{cTOTAL};
	}
}


foreach my $aa (keys %cod_usage)
{
	foreach my $codon (keys %{$cod_usage{$aa}})
	{
		if ($codon ne "aTOTAL")
		{
			print "$codon $aa\t";
			print $cod_usage{$aa}{$codon}{cTOTAL} / $grand_tot, "\t";
			print $cod_usage{$aa}{$codon}{cTOTAL}/$cod_usage{$aa}{aTOTAL}, "\n";
		}
	}
}
