#!/usr/bin/perl
# REVC_joy.pl
use strict; 
use warnings;

die "usage: REVC_joy.pl <DNA input file in Download folder>\n" unless @ARGV == 1;

my $DNA; 

open(my $in, "</Users/s130963/Downloads/$ARGV[0]") or die "error reading $ARGV[0]";
while (<$in>) {
	chomp;
	$DNA = $DNA.$_;
}
close $in;

$DNA =~ tr/[ATCG]/[TAGC]/;
$DNA = reverse $DNA;

open(my $out, ">output.txt") or die "error writing";
print $out $DNA;
close $out;