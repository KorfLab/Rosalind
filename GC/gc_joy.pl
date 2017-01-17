#!/usr/bin/perl
# gc_joy.pl
use strict;
use warnings;

die "usage: gc_joy.pl <DNA fasta file>\n" if @ARGV == 0;

my %dna;
my $current_seq;
# create hash of sequences
while (<>) {
	chomp;
	if ($_ =~ /^>/) {
		($current_seq) = $_ =~ /^>(\S+)/;
	} else { 
		$dna{$current_seq}{seq} .= $_;
	}
}

my %max_seq;
foreach my $seq_key (keys %dna) {
	# calculate %GC
	my $seq = $dna{$seq_key}{seq};
	my $gc = ($seq =~ tr/GC/GC/);
	$dna{$seq_key}{gc} = 100 * $gc / length($seq);
	
	# search for sequence with highest %GC
	if (not exists $max_seq{gc} or $max_seq{gc} < $dna{$seq_key}{gc}) {
		$max_seq{gc} = $dna{$seq_key}{gc};
		$max_seq{key} = $seq_key;
	}
}
printf "%s\n%.6f\n", $max_seq{key}, $max_seq{gc};