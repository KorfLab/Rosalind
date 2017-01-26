#!/usr/bin/perl
# dna2rna.pl
use strict; use warnings 'FATAL' => 'all';

die "usage: dna2rna.pl <string>\n" unless @ARGV == 1;

my ($string) = (@ARGV);

for (my $i = 0; $i < length($string); $i++ ) {
	$string =~ tr/T/U/;
}

print "$string\n";