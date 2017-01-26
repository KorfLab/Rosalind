#!/usr/lib/python2.7

# prtm_sam.py

import sys
from Bio.SeqUtils.ProtParam import ProteinAnalysis

try:
	prot_seq = sys.argv[1]
except IndexError:
	sys.exit("Specify protein string as ARGV1.")

analyzed_seq = ProteinAnalysis(prot_seq)

print str(analyzed_seq.molecular_weight())