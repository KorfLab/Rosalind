#!/usr/bin/perl
# complement_juan.pl
use strict; use warnings 'FATAL' => 'all';

die "usage: complement_juan.pl<string>\n" unless @ARGV == 1;

my ($string) = (@ARGV);

my $comp = reverse $string;
$comp =~ tr/ACTG/TGAC/;

print "$comp\n";