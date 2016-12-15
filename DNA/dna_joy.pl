#!/usr/bin/perl
# DNA.pl
use strict; 
use warnings;

die "usage: dna_joy.pl <DNA input file in Download folder>\n" unless @ARGV == 1;

my $DNA; 

open(my $in, "</Users/s130963/Downloads/$ARGV[0]") or die "error reading $ARGV[0]";
while (<$in>) {
	chomp;
	$DNA = $DNA.$_;
}
close $in;

my $A_count = ($DNA =~ tr/A/A/);
my $T_count = ($DNA =~ tr/T/T/);
my $C_count = ($DNA =~ tr/C/C/);
my $G_count = ($DNA =~ tr/G/G/);

open(my $out, ">output.txt") or die "error writing output";
print $out "$A_count $C_count $G_count $T_count\n";
close $out;
