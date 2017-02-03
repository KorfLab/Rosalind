#!/usr/bin/perl
#orf_kat.pl by kat
use warnings; use strict;

#rna codons to amino acids
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

die "orf_kat.pl <dna fasta file> will return distinct protein strings of dna string" unless @ARGV == 1;

open(my $in, $ARGV[0]);
my $dna = '';

#read in dna sequence
while (<$in>)
{
	chomp;
	if ($_ =~ m/^>Rosalind_\d+/) #matches header
	{	 } 
	else #not a header
	{
		#append seq to dna string
		$dna = $dna . $_;
	}
}
close $in;


#change dna to rna by changing Thymine to Uracil
my $rna = $dna;
$rna =~ tr/T/U/;

#get reverse complement of rna
my $rna2 = reverse $rna;
$rna2 =~ tr/AUGC/UACG/;

#find legitimate protein strings for all reading frames (start-stop)
my @orfs = orfs($rna);
my @orfs2 = orfs($rna2);

#append second orfs array to original
push(@orfs, @orfs2);

#new array to hold distinct protein strings
my @results;


my $found = 0;
for (my $i = 0; $i < scalar(@orfs); $i++)
{
	for (my $j = 0; $j < scalar(@results); $j++)
	{
		if ($results[$j] eq $orfs[$i])
		{
			$found = 1; #protein string has always been stored in results
		}
	}
	if (!$found) #don't store the protein string unless it is distinct
	{
		push(@results, $orfs[$i]);
	}
	$found = 0;
}

#display resulting distinct protein strings for all orfs
for (my $i = 0; $i < scalar(@results); $i++)
{
	print $results[$i], "\n";
}


#cans all forward orfs in an rna string and returns legitimate protein strings that
#start with AUG and end with stop codon
sub orfs
{
	my @orfs; #will hold protein strings found in rna
	my $ind = 0; #index for orfs array
	my ($rna) = @_; #capture rna string sent
	
	
	for (my $i = 0; $i < length($rna); $i++)
	{
		#if start codon detected...
		if (exists $codons{substr($rna, $i, 3)} and $codons{substr($rna, $i, 3)} eq 'M') #start codon found
		{
			$orfs[$ind] = '';
			my $end = 0; #will determine when stop codon has been reached
	
			my $j = $i;
			
			#stop loop if end of rna string is reached or if stop codon is reached
			while ($j + 3 < length($rna) and exists $codons{substr($rna, $j, 3)} and !$end)
			{
				
				$orfs[$ind] .= $codons{substr($rna, $j, 3)}; #add amino acid to string
				
				if(substr($rna, $j, 3) eq 'UAA' || substr($rna, $j, 3) eq 'UAG' 
				|| substr($rna, $j, 3) eq 'UGA') #stop codon
				{
					#stop codon found, set bool to true
					$end = 1;
				}
				$j += 3; #iterate by 3 to go to next codon in rna string
				
			}

			if(!$end)
			{
				$orfs[$ind] = ''; #don't store the protein string unless a stop codon was reached
			}
			else
			{
				$ind++; #iterate index for orfs array to start search for next string
			}
		}
	}
	return @orfs;
}





