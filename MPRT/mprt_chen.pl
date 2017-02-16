#!/usr/bin/perl
use strict; use warnings;
use LWP::Simple;
	
while(<>) {
	chomp;
	my $Fasta = get("http://www.uniprot.org/uniprot/$_.fasta");
	my @fasta = split("\n",$Fasta,2);

	# find N{P}[ST]{P} motif;
	print "$_\n";
	for (my $i = 0; $i < length($fasta[1]); $i++) {
		my $motif = substr($fasta[1], $i, 4);
		if ($motif =~ m/N[^P][ST][^P]/) {my $sed = $i+1; print "$sed\t";}
		else {next;}
	}
	print "\n";
}



