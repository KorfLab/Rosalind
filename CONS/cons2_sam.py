#!/usr/lib/python2.7

# cons_sam.py

import sys

try:
	infile = open(sys.argv[1])
except IndexError:
	sys.exit("Specify infile as ARGV1.")

# IUPAC ambiguity codes, just for reference
IUPAC_db = {
	"M":"AC", "R":"AG", "W":"AT",
	"S":"CG", "Y":"CT", "K":"GT",
	"V":"ACG", "H":"ACT", "D":"AGT",
	"B":"CGT", "N":"ACGT" }


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

while i < len(seq):
	A_ct = matrix_dic["A"][i]
	T_ct = matrix_dic["T"][i]
	G_ct = matrix_dic["G"][i]
	C_ct = matrix_dic["C"][i]
	
	count_list = [A_ct, T_ct, G_ct, C_ct]
	count_list.sort(reverse=True)

	top_nuc = float(count_list[0])
	second_nuc = float(count_list[1])
	third_nuc = float(count_list[2])
	last_nuc = float(count_list[3])
	
	if (second_nuc / top_nuc) < 0.5:
		# nothing ambiguous here!
		if top_nuc == A_ct:
			consensus_nuc = "a"
		elif top_nuc == T_ct:
			consensus_nuc = "t"
		elif top_nuc == G_ct:
			consensus_nuc = "g"
		elif top_nuc == C_ct:
			consensus_nuc = "c"
		if (second_nuc / top_nuc) <= 0.1: # 90% or better guess
			consensus_nuc = consensus_nuc.upper()

	else:
		# now we're getting into ambiguous sequences
		if (third_nuc / top_nuc) < 0.2:
			if top_nuc == A_ct:
				if second_nuc == T_ct:
					consensus_nuc = "W"
				elif second_nuc == C_ct:
					consensus_nuc = "M"
				else:
					consensus_nuc = "R"
			elif top_nuc == T_ct:
				if second_nuc == A_ct:
					consensus_nuc = "W"
				elif second_nuc == C_ct:
					consensus_nuc = "Y"
				else:
					consensus_nuc = "K"
			elif top_nuc == C_ct:
				if second_nuc == T_ct:
					consensus_nuc = "Y"
				elif second_nuc == A_ct:
					consensus_nuc = "M"
				else:
					consensus_nuc = "S"
			else:  # top is G
				if second_nuc == T_ct:
					consensus_nuc = "K"
				elif second_nuc == C_ct:
					consensus_nuc = "S"
				else:
					consensus_nuc = "R"
		else:
		# now we've got a three-way ambiguity, or even worse - an unknown call!
			if last_nuc == third_nuc:
				consensus_nuc = "N"
			elif last_nuc == A_ct:
				consensus_nuc = "B"
			elif last_nuc == T_ct:
				consensus_nuc = "V"
			elif last_nuc == C_ct:
				consensus_nuc = "D"
			else:
				consensus_nuc = "H"
			
			
	i += 1
	
	# disable these next couple lines if you want the ambiguous codes returned in upper case
	if consensus_nuc not in "atgcATGC":
		consensus_nuc = consensus_nuc.lower()
		
		
	consensus += consensus_nuc

print consensus

# finally, we need to print the profile matrix
A_str = "A: "
T_str = "T: "
G_str = "G: "
C_str = "C: "

# this part could be a lot simpler/prettier
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