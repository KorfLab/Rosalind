#!/usr/bin/perl
# rosalindcounting.pl
use strict; use warnings 'FATAL' => 'all';

die "usage: dna.pl <string>\n" unless @ARGV == 1;

my ($string) = (@ARGV);

my $a = ($string =~ tr/A/A/);
my $c = ($string =~ tr/C/C/);
my $g = ($string =~ tr/G/G/);
my $t = ($string =~ tr/T/T/);


print "$a $c $g $t\n";


__END__
