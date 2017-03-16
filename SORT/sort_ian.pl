#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

my @bed;
while (<>) {
	chomp;
	my ($chr, $beg, $end) = split;
	push @bed, {
		'chr' => $chr,
		'beg' => $beg,
		'end' => $end,
	};
}

print "by chrom\n";
@bed = sort {$a->{'chr'} cmp $b->{'chr'}} @bed;
printbed(\@bed);

print "by length\n";
@bed = sort {($a->{'end'} - $a->{'beg'}) <=> ($b->{'end'} - $b->{'beg'})} @bed;
printbed(\@bed);

print "by chr,beg,end\n";
@bed = sort {$a->{'chr'} cmp $b->{'chr'} or $a->{beg} <=> $b->{beg} or $a->{end} <=> $b->{end}} @bed;
printbed(\@bed);

sub printbed {
	my ($bed) = @_;
	foreach my $f (@$bed) {
		print "$f->{chr}\t$f->{beg}\t$f->{end}\n";
	}
}
