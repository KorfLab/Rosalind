#!/usr/bin/python3

#Given: A collection of DNA strings of equal length in FASTA format

#Returns: A consensus string of IUPAC codes and profile matrix for the collection

import sys, math

def find_max(nuc_counts, iters):
	"""Returns a list of indices of the nucleotides with the largest counts"""
	indices = []
	nuc_counts_cp = list(nuc_counts)	#Create copy of list for modifying
	for i in range(iters):
		index = nuc_counts_cp.index(max(nuc_counts_cp))
		indices.append(index)
		nuc_counts_cp[index] = -1
	return indices

def generate_p(nuc_counts):
	"""Generates the p vector for calculating KL"""
	p = []
	for count in nuc_counts:
		p.append(count / sum(nuc_counts))
	return p

def generate_q(nuc_counts, indices):
	"""Generates the q vector for calculating KL"""
	q = []
	for i in range(len(nuc_counts)):
		if i in indices:
			q.append(1 / len(indices))
		else:
			q.append(0)
	return q

def kl(p, q):
	"""Calculates Kullback-Leibler's Distance"""
	sum_p = 0
	sum_q = 0
	for i in range(len(p)):
		if p[i] != 0 and q[i] != 0:
			sum_p += p[i] * math.log(p[i]/q[i], 2)
			sum_q += q[i] * math.log(q[i]/p[i], 2)
	kl = sum_p + sum_q
	return kl

def get_top_nucs(indices):
	"""Returns a string of top nucleotides that will be used to retrieve IUPAC code"""
	top_nucs = ''
	sorted_indices = sorted(indices)
	for index in sorted_indices:
		if index == 0:
			top_nucs += 'A'
		elif index == 1:
			top_nucs += 'C'
		elif index == 2:
			top_nucs += 'G'
		elif index == 3:
			top_nucs += 'T'
	return top_nucs

def main():
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
		nuc_counts = [nuc_mat['A'][i], nuc_mat['C'][i], nuc_mat['G'][i], nuc_mat['T'][i]]
		p = generate_p(nuc_counts)
		#Compute KL for most likely nucleotide
		top_index = find_max(nuc_counts, 1)
		q1 = generate_q(nuc_counts, top_index)
		kl1 = abs(kl(p, q1))
		#Compute KL for 2 likely nucleotides
		top_2_indices = find_max(nuc_counts, 2)
		q2 = generate_q(nuc_counts, top_2_indices)
		kl2 = abs(kl(p, q2))
		#Compute KL for 3 likely nucleotides
		top_3_indices = find_max(nuc_counts, 3)
		q3 = generate_q(nuc_counts, top_3_indices)
		kl3 = abs(kl(p, q3))
		#Compute KL for all nucleotides
		all_indices = find_max(nuc_counts, 4)
		q4 = generate_q(nuc_counts, all_indices)
		kl4 = abs(kl(p, q4))
		#Choose lowest KL
		kl_list = [kl1, kl2, kl3, kl4]
		num_bases = kl_list.index(min(kl_list)) + 1
		if num_bases == 1:
			top_nucs = get_top_nucs(top_index)
		elif num_bases == 2:
			top_nucs = get_top_nucs(top_2_indices)
		elif num_bases == 3:
			top_nucs = get_top_nucs(top_3_indices)
		elif num_bases == 4:
			top_nucs = get_top_nucs(all_indices)
		#Get IUPAC nucleotide code
		iupac_bases = {
			'A': 'A',
			'C': 'C',
			'G': 'G',
			'T': 'T',
			'AG': 'R',
			'CT': 'Y',
			'CG': 'S',
			'AT': 'W',
			'GT': 'K',
			'AC': 'M',
			'CGT': 'B',
			'AGT': 'D',
			'ACT': 'H',
			'ACG': 'V', 
			'ACGT': 'N'
		}
		base = iupac_bases[top_nucs]
		#Change base to lowercase if needed
		if min(kl_list) >= 0.05:	#Arbitrary cutoff value
			base = base.lower()
		#Extend cons_str
		cons_str += base
	
	#Print out consensus string and profile matrix
	print(cons_str)
	nuc_order = ('A', 'C', 'G', 'T')
	for nuc in nuc_order:
		print(nuc + ': ', end = '')
		for count in nuc_mat[nuc]:
			print(str(count) + ' ', end = '')
		print()

if __name__ == "__main__":
	main()
