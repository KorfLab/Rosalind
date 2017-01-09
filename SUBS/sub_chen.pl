#!/usr/bin/perl
use strict; use warnings;

die "usage:perl sub_chen.pl <file>" unless @ARGV == 1;

open IN,"<$ARGV[0]";
my @array;
my $a;
my $b;
my $c;
my $d;
while (<>) {
	chomp;
	my $sequence = <IN>;
	my $motif = <IN>; 
	my $j=length ($sequence) - length ($motif);
       	for(my $i=0 ; $i<$j ; $i++) {
		($a,$b,$c,$d)=(split //)[$i,$i+1,$i+2,$i+3];
		$array[$i]="$a$b$c$d";
		if ($array[$i] eq "$motif") {
		print $i+1, "\t";
		}
	}
	print "\n";
	
}

