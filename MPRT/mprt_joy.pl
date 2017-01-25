#!/usr/bin/perl
# mprt_joy.pl
use strict;
use warnings;
use LWP::Simple;

die "usage: mprt_joy.pl <UniProt Protein Database access ID file>\n" if @ARGV == 0;

while (<>) {
	chomp;
	my $id = $_;
	my $url = "http://www.uniprot.org/uniprot/${id}.fasta";
	
	my $fasta = get($url); # get fasta file
	$fasta =~ s/\n//g; # remove newline
	my ($seq) = $fasta =~ /SV=\d(\w+)/; # get amino acid sequence
	
	my @pos;
	# check for motif and record positions
	for (my $i = 0; $i < length($seq); $i++) {
		my $motif = substr($seq, $i, 4); 
		if ($motif =~ m/N[^P][ST][^P]/) {
			push(@pos, $i + 1);
		}
	}	
	# print results if there are motifs
	if (@pos) {
			print "$id\n@pos\n"; 
	}
}
