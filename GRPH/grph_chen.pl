#!/usr/bin/perl
# grph_chen.pl by chen
use strict;
use warnings;
use FAlite;
use Data::Dumper;

die "usage: grhp_chen.pl <file.fasta>\n" unless @ARGV == 1;
my @seq;
open (my $fh,"< $ARGV[0]") or die;
my $fasta = new FAlite($fh);
while (my $entry = $fasta->nextEntry) {
	push @seq, $entry->seq;
}
my %hash;

foreach my $seq (@seq) {
	foreach my $ref (@seq) {
			for (my $i = 0; $i < (@seq-3); $i++) {
				for(my $j = 3; $j < @seq; $i++) {
					if (substr($seq, $i, 3) eq substr($ref, $j, 3)) {
						if ($i < $j) {
							push keys %hash, $seq;
							push values $hash{$seq},$ref;
 						 }
						else {
							next;
						}
					}
				}

			}
		}
	}
print Dumper(%hash);
close $fh;
