#!/usr/bin/env Python2.7

#hamm_sam.py

import sys

try:
	input1 = sys.argv[1]
	input2 = sys.argv[2]
except IOError:
	sys.exit("Specify the two sequences as ARGV1 and 2.")

i = 0
hammingscore = 0
while i < len(input1):
	if input1[i] == input2[i]:
		hammingscore += 0
	else:
		hammingscore += 1
	i += 1


print hammingscore