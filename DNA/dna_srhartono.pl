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
@nuc = qw(A C G T);
for (my $i = 0; $i < @nuc; $i++) {
	my $nuc = $nuc[$i];
	my $count = defined $data{$nuc} ? $data{$nuc} : 0;
	my $end = $i == @nuc - 1 ? "\n" : " ";
	print "$count$end";
}
