#!/usr/bin/perl
use warnings;
use strict;
use Data::Dumper;
use FAlite;

my %count;
my @dam;
my @seq;
my $seq;
my $codon;
my %sed;
my $sum;

die "usage cub.pl <file>" unless @ARGV == 1;
open(my $in,"<$ARGV[0]") or die;
open(my $out, ">$ARGV[0].munge") or die;
my $fasta = new FAlite($in);
while (my $entry = $fasta->nextEntry) {
	my $id = $entry->def;
	$seq = uc $entry->seq;
	push(@seq, $seq);
}	

foreach $seq (@seq) {
	for (my $i = 0; $i < length($seq); $i += 3) {
		$codon = substr($seq, $i, 3);
		if (exists $count{$codon}) {$count{$codon}++}
		else                     {$count{$codon} = 1}
        	$sum++;	 
	}	
}

foreach my $codon (sort keys %count) {
        my $frequency = $count{$codon}/$sum;
        printf "%s\t%d\t%.4f\n", $codon, $count{$codon}, $frequency;
}
close $in;



sub dsquare {
	my ($p, $q) = @_;
	my $sum = 0;
	for (my $i = 0; $i < @$p; $i++) {
		$sum += ($p->[$i] - $q->[$i]) ** 2;
	}
	return $sum;
}
