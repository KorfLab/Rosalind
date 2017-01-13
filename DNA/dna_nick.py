#!/usr/bin/env Python2.7

#dna_nick.py

#Nick Weiner's Python version of Counting Nucleotides


import sys, re

try:
    seq = sys.argv[1]
except IndexError:
    sys.exit("usage: " + sys.argv[0] + " <DNA sequence>")

alphabet = ("A","C","G","T",)
ans = ""
for letter in alphabet:
    ans += "%i " % len(re.findall(letter, seq))
print ans
