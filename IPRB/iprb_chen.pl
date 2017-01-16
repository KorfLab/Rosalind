#!/usr/bin/perl
# iprb_chen.pl  by chen
use strict;  use warnings;

die "perl iprb_chen.pl <file>" unless @ARGV == 1;
open IN,"<$ARGV[0]";
my ($k,$m,$n) =  split (" ",<IN>,3);

my $sum = $k+$m+$n;
print "$k $m $n";

# probility aa equal probility Aa2 * (Aa0 + aa0) + aa2 * (Aa1 + aa1)  :
my $pro_aa = ($m/$sum) *(($m - 1)/($sum - 1) *(1/4)  + $n/($sum - 1)*(1/2)) + ($n/$sum) * ($m/($sum - 1)*(1/2) + (($n - 1)/($sum - 1)*1));
print $pro_aa;

my $pro_A = 1 - $pro_aa;
print $pro_A;
close IN;

