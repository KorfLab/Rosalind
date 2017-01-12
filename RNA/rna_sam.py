#!/usr/bin/env Python

# rna_sam.py

import sys

try:
	input = sys.argv[1]
except IOError:
	sys.exit("Specify the line of DNA as ARGV1.")
	
output = ""
for letter in input:
	if letter == "T":
		output += "U"
	else:
		output += letter

print output