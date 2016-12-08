#!/usr/bin/perl

use strict; use warnings;

my ($input1) = @ARGV;

die "usage: $0 <file input>\n" unless @ARGV;
my %data;
my $ref; my $dna; 
open (my $in1, "<", $input1) or die "Cannot read from $input1: $!\n";
while (my $line = <$in1>) {
	chomp($line);
	if ($line =~ /^>/) {
		if (defined($dna)) {
			my ($GC) = $dna =~ tr/Gg/Gg/;
			($GC) += $dna =~ tr/Cc/Cc/;
			my $total = length($dna);
			my $perc = int($GC / $total * 100000000)/1000000;
			print "$ref\t$perc\t$GC\t$total\n";
		}
		$dna = "";
		$ref = $line;
	}
	else {
		$dna .= $line;
	}
		
}
#this is really ugly code lol
if (defined($dna)) {
	my ($GC) = $dna =~ tr/Gg/Gg/;
	($GC) += $dna =~ tr/Cc/Cc/;
	my $total = length($dna);
	my $perc = int($GC / $total * 100000000)/1000000;
	print "$ref\t$perc\t$GC\t$total\n";
}
close $in1;
