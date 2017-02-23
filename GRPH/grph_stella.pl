#!/usr/bin/perl

use strict; use warnings;

my ($input1) = @ARGV;

die "usage: $0 <fasta file>

Example:
>Rosalind_0498
AAATAAA
>Rosalind_2391
AAATTTT
>Rosalind_2323
TTTTCCC
>Rosalind_0442
AAATCCC
>Rosalind_5013
GGGTGGG

Sample Output:
Rosalind_0498 Rosalind_2391
Rosalind_0498 Rosalind_0442
Rosalind_2391 Rosalind_2323

" unless @ARGV == 1;

my %data;
my ($ref, $beg, $end);
open (my $in1, "<", $input1) or die "Cannot read from $input1: $!\n";
while (my $line = <$in1>) {
	chomp($line);
	if ($line =~ />/) {
		if (defined $end) {
			$data{end}{$end}{$ref} = 1;
		}
		$ref = $line;
		$ref =~ s/>//;
		undef $beg;
	}
	else {
		if (not defined($beg)) {
			($beg) = $line =~ /^(...)/;
			$data{beg}{$beg}{$ref} = 1;
		}
		($end) = $line =~ /(...)$/;
	}	
}
close $in1;
$data{end}{$end}{$ref} = 1;

foreach my $beg (sort keys %{$data{beg}}) {
	foreach my $ref (sort keys %{$data{beg}{$beg}}) {
		foreach my $ref2 (sort keys %{$data{end}{$beg}}) {
			next if $ref eq $ref2;
			print "$ref2 $ref\n";
		}
	}
}
