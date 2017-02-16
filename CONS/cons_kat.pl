#!/usr/bin/perl
#cons_kat.pl by Kat
use warnings FATAL => 'all'; use strict;

die "Usage: cons_kat.pl <dna fasta file> returns profile matrix and consensus string"
 unless @ARGV == 1;

#read in file
open(my $in, $ARGV[0]) or die "Error: failed to open $ARGV[0]\n";

#array to hold dna string arrays (all same length)
my @dna_strings;

#string to hold dna strings from file
my $seq;

#bool to determine if first string has been read in
my $first = 1;

#read in file to store dna seqs in dna_strings array
while (<$in>)
{
	chomp;
	if ($_ =~ m/^>Rosalind.+/) #matches header
	{	
		if($first) #if first dna header, no dna strings have been read in yet
		{
			$first = 0; #toggle bool
		}
		else #push the dna string as array onto dna_strings array
		{
			push(@dna_strings, [split("", $seq)]); #split sequence string into array
			$seq = ''; #reset seq string to empty
		}
	 } 
	else #not a header
	{
		#append seq to appropriate string
		$seq .= $_;
	}
}
push(@dna_strings, [split("", $seq)]); #push last dna array into dna_strings

close $in;

#hash to hold profile matrix
#(number of occurrences of each nt at each index in each dna string)
my %profile;	

#arrays for each nt, will be stores in %profile hash
my (@A, @C, @G, @T);

#initialize array values to 0
for (my $i = 0; $i < @{$dna_strings[0]}; $i++)
{
	$A[$i] = 0;
	$C[$i] = 0;
	$G[$i] = 0;
	$T[$i] = 0;
}

#store a ref to each nt array in %profile
$profile{A} = \@A;
$profile{C} = \@C;
$profile{G} = \@G;
$profile{T} = \@T;


#for each dna sequence in dna_strings
for (my $i = 0; $i < scalar(@dna_strings); $i++)
{
	#for each nt in the sequence
	for (my $j = 0; $j < @{$dna_strings[$i]}; $j++)
	{
		#iterate the nt array in profile matrix hash to count nt occurrences
		$profile{$dna_strings[$i][$j]}->[$j]++;
	}
}

#display the consensus string: the most frequent nt for each index of all dna_strings
for (my $i = 0; $i < @{$dna_strings[0]}; $i++)
{
	#set max nt occurence to be A profile at index i
	my $max = $profile{A}->[$i];
	#most frequent nt at index i is A
	my $cons_nt = 'A';
	
	#compare to other nt frequencies at that index and change if nec
	if ($profile{G}->[$i] > $max)
	{
		$max = $profile{G}->[$i];
		$cons_nt = 'G';
	}
	if ($profile{C}->[$i] > $max)
	{
		$max = $profile{C}->[$i];
		$cons_nt = 'C';
	}
	if ($profile{T}->[$i] > $max)
	{
		$max = $profile{T}->[$i];
		$cons_nt = 'T';
	}
	
	#display the consensus nt for each index i
	print $cons_nt;		
}

print "\n";

#display the profile matrix
foreach my $key (keys %profile)
{
	print $key, ": ";
	for (my $i = 0; $i < @{$profile{$key}}; $i++)
	{
		print $profile{$key}->[$i], " ";
	}
	print "\n";
}
