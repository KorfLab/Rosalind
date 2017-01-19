#!/usr/lib/python2.7

#iprb_sam.py

import sys

try:
	k = int(sys.argv[1])
	m = int(sys.argv[2])
	n = int(sys.argv[3])
except IndexError:
	sys.exit("Need 3 integers, k, m, and n.")

pop = k + m + n

dom_total = 1 - float(n)/pop*float(n)/(pop-1) - float(n)/pop*float(m)/(2*pop) - float(m)/(2*pop)*float(m)/(2*pop)

print str(dom_total)