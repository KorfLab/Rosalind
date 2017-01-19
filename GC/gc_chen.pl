#!/usr/bin/perl
# gc_chen.pl by chen
use strict;  use warnings;

die "usage: gc_chen.pl <file>" unless @ARGV == 1;
my ($file) = @ARGV;
open (my $in "<",$file)
my $GC_intent; 
my $GC_count;
my $max = 0;
my $number = 0;

$/ = ">"; <IN>;
while (<IN>) {
        chomp;
	my @id = (split /\n/, $_, 2);      
	$GC_count = $id[1] =~ tr/GC/GC/;
        $GC_intent = $GC_count/length($id[1]);
	print $GC_intent;
	if ($max < $GC_intent) {
		$max = $GC_intent; $number = $id[0];
	}
}
$max = 100 * $max;
printf "%s\n%.6f\n", $number, $max;
close $in;
