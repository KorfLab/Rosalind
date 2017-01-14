#!/usr/bin/perl
#gc_kat.pl by kat
use warnings; use strict;

die "Usage: gc_kat.pl <dna file.fasta> returns ID of seq with highest GC content\n"
unless @ARGV == 1;

#read in file
open(IN, "<", $ARGV[0]) or die "Error: failed to open $ARGV[0]\n";

#hash to store dna sequences
my %dna_seqs;
#var to store each header id in hash
my $id;

#read in file to store dna seqs in hash
while(<IN>)
{
	chomp;
	
	if($_ =~ m/^>(Rosalind_\d{4})/) #matches header
	{	
		$id = $1; #captures header without <
		$dna_seqs{$id} = ''; #store header as key in hash
	 } 
	else #not a header
	{
		#append seq to appropriate key
		$dna_seqs{$id} = $dna_seqs{$id} . $_;
	}
}


   
close IN;


my $max_gc = 0;
my $max_id; #to hold key of dna seq with max gc content


foreach my $key(keys %dna_seqs)
{
	my $temp_gc;
	$temp_gc = gc($dna_seqs{$key});
	if($temp_gc >= $max_gc)
	{
		#reassign max_gc if nec
		$max_gc = $temp_gc;
		$max_id = $key;
	}
}

print $max_id, "\n", $max_gc, "\n";


#subroutine gc accepts dna seq and returns gc percent
sub gc
{
	my ($dna) = @_;
	my $gc;
	$gc = ($dna =~ tr/GC/GC/) / length($dna) * 100;
	return $gc;
}

