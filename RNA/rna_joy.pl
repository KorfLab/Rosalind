#!/usr/bin/perl
# RNA.pl
use strict; 
use warnings;

die "usage: rna_joy.pl <RNA input>\n" unless @ARGV == 1;

my ($RNA) = @ARGV;
$RNA =~ tr/T/U/;
print "$RNA\n";