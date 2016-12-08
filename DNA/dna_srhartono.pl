#!/usr/bin/perl

use strict; use warnings;

my ($input1) = @ARGV;

die "usage: $0 <input>\n" unless @ARGV;

my $DNA = `cat $input1`;
chomp($DNA);

my %data;
my @nuc = split("", $DNA);
for (my $i = 0; $i < @nuc; $i++) {
	$data{$nuc[$i]} ++;
}
foreach my $nuc (sort keys %data) {
	print "$data{$nuc} ";
}
print "\n";
