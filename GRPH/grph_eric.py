#!/usr/bin/python3

#Given: A collection of DNA strings in FASTA format

#Returns: The adjacency list corresponding to O3

import sys

try:
	fil = sys.argv[1]
except IndexError:
	sys.exit('Please enter input file as ARGV1.')
	
dna_pre_suf = {}	#Dictionary containing prefixes and suffixes of DNA strings

with open(fil) as infile:
	dna = ''
	for line in infile:
		line = line.strip()
		if line[0] == '>':
			if dna != '':
				dna_pre_suf[node] = (dna[:3], dna[-3:])	#Node: (Prefix, Suffix)
			node = line[1:]
			dna = ''
		else:
			dna += line
	dna_pre_suf[node] = (dna[:3], dna[-3:])	#Last entry

adj = []	#Adjacency list

for node1, seq1 in dna_pre_suf.items():
	for node2, seq2 in dna_pre_suf.items():
		if seq1[1] == seq2[0] and node1 != node2:
			adj.append((node1, node2))
			
#Print out adjacency list
for edge in adj:
	print(' '.join(edge))
