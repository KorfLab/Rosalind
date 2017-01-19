#!/usr/lib/python2.7

#sam_prot.py

import sys

from Bio.Seq import Seq
from Bio.Alphabet import generic_rna

try:
	rna_seq = sys.argv[1]
except IndexError:
	sys.exit("Specify the RNA sequence as ARGV1.")
	
print Seq(rna_seq, generic_rna).translate()