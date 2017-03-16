#!/usr/bin/perl
use strict;
use warnings; 
use Data::Dumper;

my @array;
my $f;
while(<>) {
	my ($chr, $beg, $end) = split;
	my $length = $end - $beg;
	my $f = {
		chr => $chr,
		length => $length
	};
	push @array, $f;
}
	my @array_chr = sort {$a->{chr} = $b->{chr}} @array;
	my @array_len = sort {$a->{length} = $b->{length}} @array;
	my @array_new = sort {$a->{chr} = $b->{chr} or $a->{beg} = $b->{beg} or $a->{end} = $b->{end}} @array;
	print Dumper(@array_chr);
	print Dumper(@array_len);
	print Dumper(@array_new);
