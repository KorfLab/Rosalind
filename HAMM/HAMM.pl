#!/usr/bin/perl

use strict; use warnings;

my ($input1) = @ARGV;

die "usage: $0 <file input>\n" unless @ARGV;
open (my $in1, "<", $input1) or die "Cannot read from $input1: $!\n";
while (my $line = <$in1>) {
	chomp($line);
	my @seq1 = split("", uc($line));
	my $count = @seq1;
	$line = <$in1>; chomp($line);
	my @seq2 = split("", uc($line));
	for (my $i = 0; $i < @seq1; $i++) {
		my $yes = $seq1[$i]eq $seq2[$i] ? "\e[32;1m 1\e[0m" : "";
		$count -- if $seq1[$i] eq $seq2[$i];
		print "$seq1[$i] eq $seq2[$i]? $yes; count=$count\n";
	}
	print "$count\n";
}
close $in1;
