#!/usr/lib/python2.7

# cons_sam.py

import sys

try:
	infile = open(sys.argv[1])
except IndexError:
	sys.exit("Specify infile as ARGV1.")

# setting up storage variables
dna_strings = []
new_seq = False
seq = ""

for line in infile:
	if line[0] == ">":
		new_seq = True
		if seq != "":
			dna_strings.append(seq)
		seq = ""
	else:
		if new_seq == True:
			seq = line.strip()
			new_seq = False
		else:
			seq += line.strip()

# gotta get the last one
dna_strings.append(seq)

# next up, building a matrix
# order: A, T, G, C

matrix_dic = {}
for nucleotide in "ATGC":
	matrix_dic[nucleotide] = []
	for i in seq:
		matrix_dic[nucleotide].append(0)

# so now we've got a dictionary with a matrix for each base; next up, populating it
for seq in dna_strings:
	for i in range(len(seq)):
		matrix_dic[seq[i]][i] += 1

# next up, making the consensus sequence from this matrix
i = 0
consensus = ""

# this next part is super ugly, could be prettier
while i < len(seq):
	m = 0
	if matrix_dic["A"][i] > m:
		m = matrix_dic["A"][i]
		consensus_nuc = "A"
	if matrix_dic["T"][i] > m:
		m = matrix_dic["T"][i]
		consensus_nuc = "T"
	if matrix_dic["G"][i] > m:
		m = matrix_dic["G"][i]
		consensus_nuc = "G"
	if matrix_dic["C"][i] > m:
		m = matrix_dic["C"][i]
		consensus_nuc = "C"
	i += 1
	consensus += consensus_nuc

print consensus

# finally, we need to print the profile matrix
A_str = "A: "
T_str = "T: "
G_str = "G: "
C_str = "C: "

i = 0
while i < len(matrix_dic["A"]):
	A_str += str(matrix_dic["A"][i]) + " "
	i += 1 
i = 0
while i < len(matrix_dic["T"]):
	T_str += str(matrix_dic["T"][i]) + " "
	i += 1 
i = 0
while i < len(matrix_dic["G"]):
	G_str += str(matrix_dic["G"][i]) + " "
	i += 1 
i = 0
while i < len(matrix_dic["C"]):
	C_str += str(matrix_dic["C"][i]) + " "
	i += 1 

print A_str
print C_str
print G_str
print T_str
