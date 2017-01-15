#!/usr/bin/python3

#Reads a FASTA file and determines which of its DNA strings has the highest GC-content

import sys

try:
	fasta = sys.argv[1]
except IndexError:
	sys.exit('Please enter input file as ARGV1.')

def set_highest_gc(highest_gc, gc_count, tot_count, str_id):
	'''Compares gc-content to the current highest gc-content to determine which is higher'''
	gc_content = (float(gc_count) / tot_count) * 100
	if gc_content > highest_gc[1]:
		return (str_id, gc_content)
	else:
		return highest_gc

highest_gc = ('', 0)	#For storing the highest GC-content and its string ID
tot_count = 0
str_id = ''

with open(fasta) as infile:
	for line in infile:
		if line[0] == '>':
			if tot_count > 0:	#Skip GC-content calculation for first iteration
				highest_gc = set_highest_gc(highest_gc, gc_count, tot_count, str_id)
			str_id = line[1:].strip()	#Save string ID
			gc_count = 0				#Initialize counts
			tot_count = 0
		else:
			for nuc in line:
				if nuc == 'G' or nuc == 'C':
					gc_count += 1
					tot_count += 1
				elif nuc != '\n':
					tot_count += 1

highest_gc = set_highest_gc(highest_gc, gc_count, tot_count, str_id)	#Check last iteration

print(highest_gc[0])
print(highest_gc[1])
