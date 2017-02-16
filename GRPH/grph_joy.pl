#!/usr/bin/perl
# grph_joy.pl
use strict;
use warnings;
use Data::Dumper;

die "usage: grph_joy.pl <DNA strings in FASTA format>\n" if @ARGV == 0;

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

foreach my $seq_name (keys %dna) {
	$dna{$seq_name}{prefix} = substr($dna{$seq_name}{seq}, 0, 3);
	$dna{$seq_name}{suffix} = substr($dna{$seq_name}{seq}, -3);
}

foreach my $seq_name_1 (keys %dna) {
	foreach my $seq_name_2 (keys %dna) {
		next if ($seq_name_1 eq $seq_name_2);
		if ($dna{$seq_name_1}{suffix} eq $dna{$seq_name_2}{prefix}) {
			print "$seq_name_1 $seq_name_2\n";
		}
	}
}
