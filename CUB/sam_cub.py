#!/usr/lib/python2.7

#sam_cub.py

import sys, re

try:
	infile = open(sys.argv[1], "r")
except IndexError:
	sys.exit("Specify the DNA sequence file as ARGV1.")

# parsing the infile
dna_strings = {}
new_seq = False
seq = ""

for line in infile:
	if line[0] == ">":
		new_seq = True
		header = line.strip()[1:]
		if seq != "":
			dna_strings[header] = seq
		seq = ""
	else:
		if new_seq == True:
			seq = line.strip()
			new_seq = False
		else:
			seq += line.strip()	

# translating to proteins
total_codons = 0
codon_table = {}

for seq in dna_strings.values():
	codon_list = re.findall('...', seq)
	for codon in codon_list:
		try:
			codon_table[codon] += 1
		except KeyError:
			codon_table[codon] = 1

# by this point, we've got a database showing the most popular codons
entry_count = 0
return_string = ""
for codon, count in sorted(codon_table.items(), key=lambda (codon,count): -count):
	return_string += (codon + "\t" + str(count) + "\t")
	entry_count += 1
	if entry_count % 5 == 0:
		return_string += "\n"

print return_string

# Part 2 - figuring out which codons are most/least used, and which strings are most normal or most unusual
total_codons = sum(codon_table.values())
codon_percent_table = {}

for codon in codon_table.keys():
	codon_percent_table[codon] = float(codon_table[codon])/total_codons

highest_seq = ""
highest_score = float(0.0)
lowest_seq = ""
lowest_score = float(1.0)

for header in dna_strings.keys():
	total_score = float(0.0)
	codon_list = re.findall('...', dna_strings[header])
	for codon in codon_list:
		total_score += codon_percent_table[codon]
	
	# average for length differences
	total_score = total_score / len(codon_list)
	
	# checking if it's the most or least unusual
	if total_score > highest_score:
		highest_score = total_score
		highest_seq = header
	if total_score < lowest_score:
		lowest_score = total_score
		lowest_seq = header
	
print "The most 'normal' sequence found was " + highest_seq + ", with a score of " + str(highest_score)
print "The least 'normal' sequence found was " + lowest_seq + ", with a score of " + str(lowest_score)

infile.close()