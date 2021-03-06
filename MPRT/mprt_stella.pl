#!/usr/bin/perl

use strict; use warnings; use Getopt::Std;
use vars qw($opt_f);
getopts("f");

my ($input1) = @ARGV;

die "
usage: $0 <file>

Sample Dataset

A2Z669
B5ZC00
P07204_TRBM_HUMAN
P20840_SAG1_YEAST
Sample Output

B5ZC00
85 118 142 306 395
P07204_TRBM_HUMAN
47 115 116 382 409
P20840_SAG1_YEAST
79 109 135 248 306 348 364 402 485 501 614

\n" unless @ARGV;

open (my $in1, "<", $input1) or die "Cannot read from $input1: $!\n";
while (my $line = <$in1>) {
	chomp($line);
	my $id = $line;

	# get real ID
	my @id = split("_", $id);
	$id = $id[0];

	#
	my $seq;
	system("wget --output-document=$id.fa -q http://www.uniprot.org/uniprot/$id.fasta") == 0 or die "Failed to retrieve $id: $!\n" if ($opt_f) or (not -e "$id.fa" or (-e "$id.fa" and -s "$id.fa" == 0));
	#my @fasta = `curl http://www.uniprot.org/uniprot/$id.fasta 2>/dev/null`; #curl sometimes sucks
	my @fasta = `cat $id.fa`;
	foreach my $fasta (@fasta[0..@fasta-1]) {
		chomp($fasta);
		next if $fasta =~ /^>/;
		$seq .= $fasta;
	}
	my $print = "$line\n";
	my $pos = 0; my $check = 0;
	while ($seq	=~ /N/g) {
		$pos = length($`) + 1;
		my $curr = $& .substr($', 0, 3);
		if ($curr =~ /^N[^P][ST][^P]/) {
			$print .= " " if $check != 0;
			$print .= "$pos";
			$check = 1;
		}
	}
	print "$print\n" if $check == 1;
}
close $in1;
