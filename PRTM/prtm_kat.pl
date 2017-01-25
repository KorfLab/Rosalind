#!/usr/bin/perl
#prtm_kat.pl by Kat
use warnings; use strict;

#hash of monoisotropic masses for 20 amino acids
my %monoiso_masses = (
	A => 71.03711,
	C => 103.00919,
	D => 115.02694,
	E => 129.04259,
	F => 147.06841,
	G => 57.02146,
	H => 137.05891,
	I => 113.08406,
	K => 128.09496,
	L => 113.08406,
	M => 131.04049,
	N => 114.04293,
	P => 97.05276,
	Q => 128.05858,
	R => 156.10111,
	S => 87.03203,
	T => 101.04768,
	V => 99.06841,
	W => 186.07931,
	Y => 163.06333,
);

die "usage: prtm_kat.pl <protein string file> returns monoisotropic mass" unless @ARGV == 1;

open(my $in, $ARGV[0]);

#read in protein string from file
my $prot = <$in>;
chomp($prot);

#separate by amino acids
my @aacids = split("", $prot);

my $mass = 0;

#sum all amino acid masses in protein string
for (my $i = 0; $i < scalar(@aacids); $i++)
{
	$mass += $monoiso_masses{$aacids[$i]};
}

print $mass, "\n";