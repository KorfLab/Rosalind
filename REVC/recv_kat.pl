#!usr/bin/perl
#revc_kat.pl by Kat
use warnings; use strict;

die "usage: revc_kat.pl; <dna strand 1>" unless @ARGV == 1;

#receive strand as an string
my ($dna1) = @ARGV;

#split dna string into array
my @dna1 = split("", $dna1);

#make array to hold complementary strand
my @dna2;
my $ct = 0;

#reverse strand 1
for(my $i = scalar(@dna1) - 1; $i >= 0; $i--)
{
	$dna2[$ct] = $dna1[$i];
	$ct++;
}


#store strand2 as string
my $dna2 = join("", @dna2);

#change nt to base pair complements
$dna2 =~ tr/ATGC/TACG/;
print $dna2, "\n";