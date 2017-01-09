#!/usr/bin/perl
# gc_chen.pl by chen
use strict;  use warnings;

die "usage: gc_chen.pl <file>" unless @ARGV == 1;

open IN,"<$ARGV[0]";
my $GC_intent; 
my $C_count;
my $G_count;
my $GC_count;
my $max = 0;
my $number = 0;

$/ = ">";<IN>;
while (<IN>) {
        chomp;
	my @id = (split /\n/,$_,2);      
	$C_count = $id[1] =~ tr/C/C/;
	$G_count = $id[1] =~ tr/G/G/;
        $GC_count = $C_count+$G_count; 
        $GC_intent =int(100000000*$GC_count/length $id[1])/1000000;
	if ($max < $GC_intent) {
		$max = $GC_intent; $number = $id[0];
	}
}
print "$number\n$max\n";
close IN;

 




