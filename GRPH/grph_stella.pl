#!/usr/bin/perl

use strict; use warnings;

my ($input1) = @ARGV;

die "usage: $0 <file>

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
Sample Output

Rosalind_0498 Rosalind_2391
Rosalind_0498 Rosalind_0442
Rosalind_2391 Rosalind_2323

" unless @ARGV;

my %seq; my $ref;
open (my $in1, "<", $input1) or die "Cannot read from $input1: $!\n";
while (my $line = <$in1>) {
	chomp($line);
	if ($line =~ />/) {
		$ref = $line;
		$ref =~ s/>//;
	}
	else {
		$seq{$ref} .= $line;
	}	
}
close $in1;
my %done;
my %data;my $count = 0;
foreach my $ref (sort keys %seq) {
	my $line = $seq{$ref};
	$count ++;
	my ($beg) = $line =~ /^(...)/;
	my ($end) = $line =~ /(...)$/;
	$data{beg}{$beg}{$ref} = $line;
	$data{end}{$end}{$ref} = $line;
}
foreach my $beg (sort keys %{$data{beg}}) {
	foreach my $ref (sort keys %{$data{beg}{$beg}}) {
		foreach my $ref2 (sort keys %{$data{end}{$beg}}) {
			next if $ref eq $ref2;
			if (defined $done{$ref}) {
				next if defined $done{$ref}{$ref2};
			}
			$done{$ref2}{$ref} = 1;
		}
	}
}
foreach my $ref (keys %done) {
	foreach my $ref2 (keys %{$done{$ref}}) {
		print "$ref $ref2\n";
	}
}	
