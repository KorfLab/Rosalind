#!/usr/bin/python3

#Translates a given mRNA string into its corresponding protein sequence

import sys

try:
	rna_file = sys.argv[1]
except IndexError:
	sys.exit('Please enter input file as ARGV1.')
	
with open(rna_file) as infile:
	rna = infile.read()

prot_dict = {
	'UUU': 'F',      'CUU': 'L',      'AUU': 'I',      'GUU': 'V',
	'UUC': 'F',      'CUC': 'L',      'AUC': 'I',      'GUC': 'V',
	'UUA': 'L',      'CUA': 'L',      'AUA': 'I',      'GUA': 'V',
	'UUG': 'L',      'CUG': 'L',      'AUG': 'M',      'GUG': 'V',
	'UCU': 'S',      'CCU': 'P',      'ACU': 'T',      'GCU': 'A',
	'UCC': 'S',      'CCC': 'P',      'ACC': 'T',      'GCC': 'A',
	'UCA': 'S',      'CCA': 'P',      'ACA': 'T',      'GCA': 'A',
	'UCG': 'S',      'CCG': 'P',      'ACG': 'T',      'GCG': 'A',
	'UAU': 'Y',      'CAU': 'H',      'AAU': 'N',      'GAU': 'D',
	'UAC': 'Y',      'CAC': 'H',      'AAC': 'N',      'GAC': 'D',
	'UAA': 'Stop',   'CAA': 'Q',      'AAA': 'K',      'GAA': 'E',
	'UAG': 'Stop',   'CAG': 'Q',      'AAG': 'K',      'GAG': 'E',
	'UGU': 'C',      'CGU': 'R',      'AGU': 'S',      'GGU': 'G',
	'UGC': 'C',      'CGC': 'R',      'AGC': 'S',      'GGC': 'G',
	'UGA': 'Stop',   'CGA': 'R',      'AGA': 'R',      'GGA': 'G',
	'UGG': 'W',      'CGG': 'R',      'AGG': 'R',      'GGG': 'G',
}

prot_seq = ''
rna_cp = rna	#Make copy of RNA for modifying

while len(rna_cp) >= 3:
	codon = rna_cp[:3]
	if prot_dict[codon] != 'Stop':
		prot_seq += prot_dict[codon]	#Add protein
		rna_cp = rna_cp[3:]				#Remove the 3 bases already processed
	else:
		break	#Stop codon reached

print(prot_seq)
