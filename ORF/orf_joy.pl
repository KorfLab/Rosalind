#!/usr/bin/perl
# orf_joy.pl
use strict;
use warnings;

die "usage: orf_joy.pl <DNA fasta file>\n" if @ARGV == 0;

my $dna;
while (<>) {
	if ($_ =~ /^[^>]/) {
		chomp;
		$dna .= $_;
	}
}

die "no input" unless $dna; 

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
	'TAA' => ' ',      'CAA' => 'Q',      'AAA' => 'K',      'GAA' => 'E',
	'TAG' => ' ',      'CAG' => 'Q',      'AAG' => 'K',      'GAG' => 'E',
	'TGT' => 'C',      'CGT' => 'R',      'AGT' => 'S',      'GGT' => 'G',
	'TGC' => 'C',      'CGC' => 'R',      'AGC' => 'S',      'GGC' => 'G',
	'TGA' => ' ', 	   'CGA' => 'R',      'AGA' => 'R',      'GGA' => 'G',
	'TGG' => 'W',      'CGG' => 'R',      'AGG' => 'R',      'GGG' => 'G', 
);

my @orf = search_orf($dna, \%AA);

# find ORF on 3'5' frame
(my $rev = $dna) =~ tr/[ATCG]/[TAGC]/;
$rev = reverse $rev;
push(@orf, search_orf($rev, \%AA));

# print unique values
my @uniq_orf;
push(@uniq_orf, $orf[0]);
for (my $i = 1; $i < @orf; $i++) {
	for (my $j = 0; $j < @uniq_orf; $j++) {
		if ($orf[$i] eq $uniq_orf[$j]) { last }
		elsif ($j == (scalar(@uniq_orf) - 1)) { push(@uniq_orf, $orf[$i]); last }
	}
}
print join("\n", @uniq_orf), "\n";


sub search_orf{
	my ($dna, $aa_ref) = @_;
	my %AA = %$aa_ref;
	my @orf;

	for (my $i = 0; $i < (length($dna)); $i++) {

		# search for start codon
		my $start = substr($dna, $i, 3);
		if ($start eq 'ATG') {
		my ($aa_seq, $codon);
		
			# translation
			for (my $j = $i; $j < length($dna) - 2; $j+= 3) {
				$codon = substr($dna, $j, 3);

				if (length($codon) != 3)   { last }
				if ($AA{$codon} eq ' ') { last } # exist loop at stop codon
				else 			   		   { $aa_seq .= $AA{$codon} }	
			}
			if ($AA{$codon} eq ' ') {
				push (@orf, $aa_seq)	
			}
		}
	}
	return(@orf)
}