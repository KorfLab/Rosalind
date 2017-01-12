#!/usr/bin/env Python

# RNA.py

import sys

input = sys.argv[1]
output = ""
for letter in input:
	if letter == "T":
		output += "U"
	else:
		output += letter

print output