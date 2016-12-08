#!/usr/bin/perl -w
use strict;

open IN,"<$ARGV[0]";
while (<IN>)  {
my $reverse_seq = reverse $_;
# print "$reverse_seq\n";
$reverse_seq =~ tr/ATCG/TAGC/;
print "$reverse_seq\n";
}
close IN;  
