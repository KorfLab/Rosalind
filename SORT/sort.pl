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
	my @array_new = sort {$a->{chr} = $b->{chr} or $a->{length} = $b->{length}} @array;
	print Dumper(@array_new);
	
