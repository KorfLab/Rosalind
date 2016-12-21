#!/usr/bin/perl 
# revc_chen.pl by chen
use strict;  use warnings;

die "usage: revc_chen.pl <file>" unless @ARGV == 1;

while (<>)  {
my $reverse_seq = reverse $_;
# print "$reverse_seq\n";
$reverse_seq =~ tr/ATCG/TAGC/;
print "$reverse_seq\n";
}

