#!/usr/bin/python3

#Given: A collection of DNA strings of equal length in FASTA format

#Returns: A consensus string of IUPAC codes and profile matrix for the collection

import sys, collections

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

def one_likely(cons_str, top_nucs, counter):
	"""Extends cons_str when there is one most likely nucleotide"""
	if top_nucs == ['A']:
		base = 'a'
	elif top_nucs == ['C']:
		base = 'c'
	elif top_nucs == ['G']:
		base = 'g'
	elif top_nucs == ['T']:
		base = 't'
	if counter[0] == 3:
		base = base.upper()
	cons_str += base
	return cons_str

def two_likely(cons_str, top_nucs, counter):
	"""Extends cons_str when there are two equally likely nucleotides"""
	if top_nucs == ['A', 'G']:
		base = 'r'
	elif top_nucs == ['C', 'T']:
		base = 'y'
	elif top_nucs == ['C', 'G']:
		base = 's'
	elif top_nucs == ['A', 'T']:
		base = 'w'
	elif top_nucs == ['G', 'T']:
		base = 'k'
	elif top_nucs == ['A', 'C']:
		base = 'm'
	if counter[0] == 2:
		base = base.upper()
	cons_str += base
	return cons_str

def three_likely(cons_str, top_nucs, counter):
	"""Extends cons_str when there are three equally likely nucleotides"""
	if top_nucs == ['C', 'G', 'T']:
		base = 'b'
	elif top_nucs == ['A', 'G', 'T']:
		base = 'd'
	elif top_nucs == ['A', 'C', 'T']:
		base = 'h'
	elif top_nucs == ['A', 'C', 'G']:
		base = 'v'
	if counter[0] == 1:
		base = base.upper()
	cons_str += base
	return cons_str

def all_likely(cons_str):
	"""Extends cons_str when all nucleotides are equally likely"""
	cons_str += 'N'
	return cons_str

#Create consensus string
cons_str = ''
for i in range(LEN_SEQ):
	nuc_counts = [nuc_mat['A'][i], nuc_mat['C'][i], nuc_mat['G'][i], nuc_mat['T'][i]]
	counter = collections.Counter(nuc_counts)	#Counter of nucleotide counts
	m = -1	#Max count
	for i in range(len(nuc_counts)):
		if nuc_counts[i] > m:
			m = nuc_counts[i]
			if i == 0:
				top_nucs = ['A']
			elif i == 1:
				top_nucs = ['C']
			elif i == 2:
				top_nucs = ['G']
			elif i == 3:
				top_nucs = ['T']
		elif nuc_counts[i] == m:
			if i == 1:
				top_nucs.append('C')
			elif i == 2:
				top_nucs.append('G')
			elif i == 3:
				top_nucs.append('T')
	if len(top_nucs) == 1:
		cons_str = one_likely(cons_str, top_nucs, counter)
	elif len(top_nucs) == 2:
		cons_str = two_likely(cons_str, top_nucs, counter)
	elif len(top_nucs) == 3:
		cons_str = three_likely(cons_str, top_nucs, counter)
	elif len(top_nucs) == 4:
		cons_str = all_likely(cons_str)
	
#Print out consensus string and profile matrix
print(cons_str)
nuc_order = ('A', 'C', 'G', 'T')
for nuc in nuc_order:
	print(nuc + ': ', end = '')
	for count in nuc_mat[nuc]:
		print(str(count) + ' ', end = '')
	print()
