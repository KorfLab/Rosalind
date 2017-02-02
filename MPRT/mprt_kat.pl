#!/usr/bin/perl
#mprt_kat.pl by kat
use warnings; use strict;
use LWP::Simple qw(get);


die "Usage: mprt_kat.pl <list of Uniprot ID's> returns ID and locations of
N-glycosylation motif\n" unless @ARGV > 0;

#hash to store Unicode protein strings
my %prots;

for (my $i = 0; $i < scalar(@ARGV); $i++) 
{
	#access each protein id fasta page
	my $url = 'http://www.uniprot.org/uniprot/' . $ARGV[$i] . '.fasta';
	
	#extract protein fasta, store in prot hash using Uniprot ID as key
	$prots{$ARGV[$i]} = get $url;
}


foreach my $key (keys %prots)
{
		#delete header and newlines from each protein string
		$prots{$key} =~ s/^>sp.+\n//;
		$prots{$key} =~ s/\n//g;
}


foreach my $key(keys %prots)
{
	#copy protein string for searching
	my $temp = $prots{$key};
	
	#pos will track the location of each N-glycosylation occurrence
	my $pos = 0;
	
	#only display proteins with matches
	if ($temp =~ /N[^P][ST][^P]/)
	{
		print $key, "\n";
		
		while ($temp =~ /N([^P][ST][^P])/) #captures the motif excluding first N
		{ 
			#position is length of seq preceding motif + 1 (for excluded N)
			$pos += length($`) + 1;
			
			#display position of motif
			print $pos, " ";
			
			#concatenate motif to sequence following it and search
			#(effectively iterates string index by 1)
			$temp = $1 . $';
		}	
		print "\n";
	}
}
