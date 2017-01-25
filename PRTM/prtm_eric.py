#!/usr/bin/python3

#Given a protein string, calculates the total weight of the protein in Da

import sys

try:
	fil = sys.argv[1]
except IndexError:
	sys.exit('Please enter input file as ARGV1.')
	
with open(fil) as infile:
	prot = infile.readline().strip()

aa_mass_dict = {
	'A': 71.03711,
	'C': 103.00919,
	'D': 115.02694,
	'E': 129.04259,
	'F': 147.06841,
	'G': 57.02146,
	'H': 137.05891,
	'I': 113.08406,
	'K': 128.09496,
	'L': 113.08406,
	'M': 131.04049,
	'N': 114.04293,
	'P': 97.05276,
	'Q': 128.05858,
	'R': 156.10111,
	'S': 87.03203,
	'T': 101.04768,
	'V': 99.06841,
	'W': 186.07931,
	'Y': 163.06333
}

prot_weight = 0
for aa in prot:
	prot_weight += aa_mass_dict[aa]

print(prot_weight)
