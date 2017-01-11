#!/usr/bin/perl
# rna_chen.pl
use strict;  use warnings;

die "usage:rna_che.pl <file>" unless @ARGV == 1;

while (<>) {
	$_ =~ tr/T/U/;
	print $_;
}

