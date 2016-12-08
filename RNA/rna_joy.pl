#!/usr/bin/perl
# ENA.pl
use strict; 
use warnings;

my ($RNA) = @ARGV;
$RNA =~ tr/T/U/;
print "$RNA\n";