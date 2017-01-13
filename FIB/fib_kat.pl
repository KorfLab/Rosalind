#!/usr/bin/perl
#fib_kat.pl by Kat
use warnings; use strict;


die "usage: fib_kat.pl <n months> <k pairs> returns total pairs of rabbits
after n months, at k pairs per litter\n" unless @ARGV == 2;

my($months, $pairs) = @ARGV;

print rabbits($months), "\n";



#subroutine rabbits receives months and recursively calculates total pairs
sub rabbits
{
	my $total;
	
	#extract month variable
	my ($months) = @_;
	
	#only one pair of rabbits for first 2 months
	if($months == 1 || $months == 2)
	{
		$total = 1;
	}
	#Fibonacci seq
	else
	{
		$total += rabbits($months-2) * $pairs + rabbits ($months-1);
	}
	return $total;
}


