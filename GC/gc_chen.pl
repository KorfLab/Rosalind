#!/usr/bin/perl
# gc_chen.pl by chen
use strict;  use warnings;

die "usage: gc_chen.pl <file>" unless @ARGV == 1;

open IN,"<$ARGV[0]";
my $GC_intent; 
my $C_count;
my $G_count;
my $GC_count;
my $seq;
my %hash = {};
$/ = ">";<IN>;
while (<IN>) {
        chomp;
	my @id = (split /\n/,$_,2);      
        #       print "$id[1]\n";
	$C_count = $id[1] =~ tr/C/C/;
	$G_count = $id[1] =~ tr/G/G/;
        $GC_count = $C_count+$G_count; 
        $GC_intent =int(100000000*$GC_count/length $id[1])/1000000;
	$hash{$GC_intent} = $id[0];
}
my $max_gc = pop sort values $GC_intent;
my $max_value = $hash{$max_gc};   
print "$max_gc $max_value";
close IN;

 




