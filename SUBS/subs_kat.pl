#!usr/bin/perl
#subs_kat.pl by Kat
use warnings; use strict;

die "usage: subs_kat.pl; <dna string> <dna substring>
returns locations of substrings in string" unless @ARGV == 2;
	
#strings to hold input
my ($dna, $dna_sub) = @ARGV;

#variable to hold location index of each substr occurence
my $loc = index($dna, $dna_sub);

#index() will return -1 when substring is no longer found in string
while($loc != -1)
{
	print $loc + 1, " ";
	#iterate offset to search string after each occurence
	my $offset = $loc + 1;
	$loc = index($dna, $dna_sub, $offset)
}
print "\n";