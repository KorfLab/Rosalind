#!/usr/lib/python2.7

# gc_sam.py

import sys

try:
	infile = open(sys.argv[1], "r")
except IndexError:
	sys.exit("Specify the FASTA file as ARGV1.")

highest_name = ""
highest_GC = 0
	
for line in infile:
	if line[0] == ">":
		seq_name = line[1:].strip()
	else:
		GC = 0
		length = 0
		for base in line:
			if base == "G" or base == "C":
				GC += 1
			length += 1
		GC_cont = float(100.00 * GC / length)
		
		if GC_cont > highest_GC:
			highest_GC = GC_cont
			highest_name = seq_name

print highest_name
print str(highest_GC)