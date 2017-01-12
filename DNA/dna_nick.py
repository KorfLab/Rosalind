"""
Nick Weiner's Python version of Counting Nucleotides
"""

import re
alphabet = ("A","C","G","T",)
seq = raw_input("Enter your sequence: ")
ans = ""
for letter in alphabet:
    ans += "%i " % len(re.findall(letter, seq))
print ans
