#!/usr/bin/python3

#Given: A collection of DNA strings of equal length in FASTA format

#Returns: A consensus string and profile matrix for the collection

import sys

try:
	fil = sys.argv[1]
except IndexError:
	sys.exit('Please enter input file as ARGV1.')
	
dna_str = []	#List containing DNA strings

with open(fil) as infile:
	seq = ''
	for line in infile:
		line = line.strip()
		if line[0] == '>':
			if seq != '':
				dna_str.append(seq)
			seq = ''
		else:
			seq += line
	dna_str.append(seq)	#Last entry
	
LEN_SEQ = len(dna_str[0])	#Length of each DNA sequence

#Construct dictionary for storing nucleotide counts
nuc_mat = {'A': [0] * LEN_SEQ, 'C': [0] * LEN_SEQ, 'G': [0] * LEN_SEQ, 'T': [0] * LEN_SEQ}

#Fill in nuc_mat
for seq in dna_str:
	for i in range(LEN_SEQ):
		nuc_mat[seq[i]][i] += 1
			
#Create consensus string
cons_str = ''
for i in range(LEN_SEQ):
	m = -1
	if nuc_mat['A'][i] > m:
		m = nuc_mat['A'][i]
		nuc = 'A'
	if nuc_mat['C'][i] > m:
		m = nuc_mat['C'][i]
		nuc = 'C'
	if nuc_mat['G'][i] > m:
		m = nuc_mat['G'][i]
		nuc = 'G'
	if nuc_mat['T'][i] > m:
		m = nuc_mat['T'][i]
		nuc = 'T'
	cons_str += nuc
	
#Print out consensus string and profile matrix
print(cons_str)
nuc_order = ('A', 'C', 'G', 'T')
for nuc in nuc_order:
	print(nuc + ': ', end = '')
	for count in nuc_mat[nuc]:
		print(str(count) + ' ', end = '')
	print()
