#!/usr/bin/perl
# cub_joy.pl
use strict;
use warnings;
use Data::Dumper;

my %AA = (
	'TTT' => 'F',      'CTT' => 'L',      'ATT' => 'I',      'GTT' => 'V',
	'TTC' => 'F',      'CTC' => 'L',      'ATC' => 'I',      'GTC' => 'V',
	'TTA' => 'L',      'CTA' => 'L',      'ATA' => 'I',      'GTA' => 'V',
	'TTG' => 'L',      'CTG' => 'L',      'ATG' => 'M',      'GTG' => 'V',
	'TCT' => 'S',      'CCT' => 'P',      'ACT' => 'T',      'GCT' => 'A',
	'TCC' => 'S',      'CCC' => 'P',      'ACC' => 'T',      'GCC' => 'A',
	'TCA' => 'S',      'CCA' => 'P',      'ACA' => 'T',      'GCA' => 'A',
	'TCG' => 'S',      'CCG' => 'P',      'ACG' => 'T',      'GCG' => 'A',
	'TAT' => 'Y',      'CAT' => 'H',      'AAT' => 'N',      'GAT' => 'D',
	'TAC' => 'Y',      'CAC' => 'H',      'AAC' => 'N',      'GAC' => 'D',
	'TAA' => '*',      'CAA' => 'Q',      'AAA' => 'K',      'GAA' => 'E',
	'TAG' => '*',      'CAG' => 'Q',      'AAG' => 'K',      'GAG' => 'E',
	'TGT' => 'C',      'CGT' => 'R',      'AGT' => 'S',      'GGT' => 'G',
	'TGC' => 'C',      'CGC' => 'R',      'AGC' => 'S',      'GGC' => 'G',
	'TGA' => '*', 	   'CGA' => 'R',      'AGA' => 'R',      'GGA' => 'G',
	'TGG' => 'W',      'CGG' => 'R',      'AGG' => 'R',      'GGG' => 'G', 
);

# Part 1
die "usage: cub_joy.pl <coding sequences in FASTA format>\n" if @ARGV == 0;

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

my $total_count;
my $codon_usage;
foreach my $seq_name (keys %dna) {
	for (my $i = 0; $i < length($dna{$seq_name}{seq}); $i+= 3) {
		my $codon = substr($dna{$seq_name}{seq}, $i, 3);
		my $aa = $AA{$codon};
		$codon_usage->{$aa}{$codon}{count}++;
		$total_count++
	}
}


foreach my $aa (keys %{$codon_usage}) {
	my $aa_count;
	print "\n$aa \n";
	foreach my $codon (keys %{$codon_usage->{$aa}}) {
		$aa_count += $codon_usage->{$aa}{$codon}{count};
	}
	foreach my $codon (keys %{$codon_usage->{$aa}}) {
		$codon_usage->{$aa}{$codon}{freq} = $codon_usage->{$aa}{$codon}{count} / $total_count;
		$codon_usage->{$aa}{$codon}{fraction} = $codon_usage->{$aa}{$codon}{count} / $aa_count;
		print "$codon $codon_usage->{$aa}{$codon}{fraction} \n";
	}
}