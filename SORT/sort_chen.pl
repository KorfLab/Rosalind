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
		end => $end,
		beg => $beg,
		length => $length
	};
	push @array, $f;
}

my @array_chr = sort {$a->{chr} = $b->{chr}} @array;
my @array_len = sort {$a->{length} = $b->{length}} @array;
my @array_new = sort {$a->{chr} = $b->{chr} or $a->{beg} = $b->{beg} or $a->{end} = $b->{end}} @array;

print "sort chr:\n";
foreach my $k (@array_chr) {
	print "k->{chr}\t$k->{length}\t$k->{beg}\t$k->{end}\n";
}
print"sort length:\n";
foreach my $k (@array_len) {
	print "$k->{chr}\t$k->{length}\t$k->{beg}\t$k->{end}\n";
}
print"sort all:\n";
foreach my $k (@array_new) {
	print "$k->{chr}\t$k->{length}\t$k->{beg}\t$k->{end}\n";
}
