#!/usr/lib/python2.7

# grph_sam.py

import sys

try:
	infile = open(sys.argv[1])
except IndexError:
	sys.exit("Specify infile as ARGV1.")

# checking overlap function
def if_overlap(seq1, seq2, k):
	return seq1[-k:] == seq2[:k]	# returns True if the last k of seq1 match the first k of seq2

# setting up variables
dna_strings = {}
new_seq = False
seq = ""
k = 3

# read in the infile
for line in infile:
	if line[0] == ">":
		new_seq = True
		if seq != "":
			dna_strings[seq_ID] = seq
		seq_ID = line.strip()[1:]
		seq = ""
	else:
		if new_seq == True:
			seq = line.strip()
			new_seq = False
		else:
			seq += line.strip()
infile.close()

adjacency_list = []

for entry1 in dna_strings.keys():
	for entry2 in dna_strings.keys():
		if entry1 != entry2:
			if if_overlap(dna_strings[entry1], dna_strings[entry2], k):
				adjacency_list.append(entry1 + " " + entry2)

for item in set(adjacency_list):
	print item