#!/usr/bin/python3

#Given n number of months and k number of rabbit pairs produced by each pair in each 
#generation, determines the number of pairs present at the end of n months

import sys

try:
	fil = sys.argv[1]
except IndexError:
	sys.exit('Please enter input file as ARGV1.')
	
with open(fil) as infile:
	nums = infile.read().split()
	n, k = int(nums[0]), int(nums[1])

def rec(n, k):
	'''Determines number of rabbits present by using recursion'''
	if n == 1 or n == 2:
		return 1
	else:
		return rec(n-1, k) + rec(n-2, k)*k

print(rec(n, k))
