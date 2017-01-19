#!/usr/lib/python2.7

# fib_sam.py

import sys

try:
	months = int(sys.argv[1])
	litter = int(sys.argv[2])
except IndexError:
	sys.exit("Specify months as ARGV1, litter size as ARGV2.")

n = 0
rabbits = 0
babies = 1

new_rabbits = 0

while n < months:
	new_rabbits = rabbits + babies
	babies = rabbits * litter
	rabbits = new_rabbits
	n += 1

print str(rabbits)	