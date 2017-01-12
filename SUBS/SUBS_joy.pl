#!/usr/bin/perl
# SUBS_joy.pl
use strict; 
use warnings;

die "usage: SUBS_joy.pl <DNA input file in Download folder>
note: file should contain two lines: 
		first line: DNA sequence 
		second line: substring of above sequence\n" unless @ARGV == 1;

my @seq;

open(my $in, "</Users/s130963/Downloads/$ARGV[0]") or die "error reading $ARGV[0]";
while (<$in>) {
	chomp; 
	push(@seq, $_);
}
close $in;

die "incorrect number of lines in the input file\n" unless @seq == 2;

my ($DNA, $substring) = @seq;
my @pos;

for (my $j = 1; $j <= (length($DNA) -length($substring) +1); $j++) {
	my $key = substr($DNA, $j -1, length($substring));
	if ($key =~ m/$substring/) {
		push(@pos, $j);
	}
}

if (@pos) { 
	print join(" ", @pos), "\n";
} else { 
	print "no match found\n"
}
