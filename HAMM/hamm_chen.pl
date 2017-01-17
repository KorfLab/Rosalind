#!/usr/bin/perl
# hamm_chen.pl by chen
use strict;  use warnings;

die "usage :perl hamm_chen.pl <file>" unless @ARGV == 1;
open IN, "<$ARGV[0]";
chomp (my $seq1 = <IN>) ;
chomp (my $seq2 = <IN>) ;

my $j = 0;
my @seq1 = split ("",$seq1);
my @seq2 = split ("",$seq2);
#print "$seq1-------$seq2";
for (my $i = 0; $i <= length $seq1; $i++) {
	if (pop @seq1 eq pop @seq2) {
		} else {
		$j ++;
		}
		} 
print "$j\n";

close IN;
