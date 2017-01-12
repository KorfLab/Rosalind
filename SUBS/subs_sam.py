#!/usr/bin/env Python2.7

#subs_sam.py

import sys

try:
	seq = sys.argv[1]
	sub = sys.argv[2]
except IndexError:
	sys.exit("Specify files as ARGV1 and 2.")
	
splitseq = seq.split(sub)

hits = []

for i in range(len(seq) - 1):
	if seq[i:i+len(sub)] == sub:
		hits.append(i + 1)
		
print hits