#!/usr/bin/perl
#grph_kat.pl by kat
use warnings FATAL => 'all'; use strict;

die "Usage: grph_kat.pl <dna fasta file> returns adjacency list of Overlap Graph O3"
 unless @ARGV == 1;
 

open(my $in, $ARGV[0]);

#hash to store dna strings from fasta file
my %dna_seqs;

#variables to capture fasta id's
my $id;
my $tempid;

#temporarily stores dna
my $dna = '';

#bool to determine if first string has been read in
my $first = 1;

#will store the prefix/suffix of each dna string
my $prefix;
my $suffix;


#read in file to store dna seqs in hash
while (<$in>)
{
	chomp;
	
	if ($_ =~ m/^>(.+)/) #matches header
	{	
		$id = $1; #captures header without <
		$dna_seqs{$id} = ''; #store header as key in hash
		
				
		if ($first) #if first dna header, no dna strings have been read in yet
		{
			$first = 0; #toggle bool
		}
		else #find and store the prefix/suffix of the dna string
		{
			$prefix = substr($dna, 0, 3);
			$suffix = substr($dna, -3);
			
			#tempid still has id of dna string read in previously
			$dna_seqs{$tempid} = { #store prefix/suffix to the corresponding dna id
				suffix => $suffix,
				prefix => $prefix,
			};
			
			$dna = ''; #reset dna string to empty
		}	
	 } 
	else #not a header
	{
		#append sequence
		$dna .= $_;
		$tempid = $id;
	}
}
close $in;

#post loop read to store prefix/suffix of final string
$prefix = substr($dna, 0, 3);
$suffix = substr($dna, -3);
$dna_seqs{$tempid} = {
	suffix => $suffix,
	prefix => $prefix,
};


foreach my $id (keys %dna_seqs)
{
	#compare suffix of each string to prefix of every other string
	foreach my $cmpid (keys %dna_seqs)
	{
		if ($cmpid ne $id) #no directed loops in overlap graph, don't compare to self
		{
			if ($dna_seqs{$id}{suffix} eq $dna_seqs{$cmpid}{prefix})
			{
				print "$id $cmpid\n";
			}
		} 
	}
}		