#!/usr/bin/env Python2.7

#revc_nick.py

import argparse
DNA_seq = ""
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("DNAsequence", help="DNA sequence or file to be reverse complemented")
    parser.add_argument("outputf", nargs="?", help = "optional output file name", default = "outputf.txt")
    args = parser.parse_args()

    
    DNA_seq = ""
    if (args.DNAsequence).endswith(".txt"):
        f = open(args.DNAsequence,"r")
        for line in f:
            DNA_seq += line
        f.close()
    else:
        DNA_seq = args.DNAsequence
    rev_seq = DNA_seq[::-1]

    compl_seq = ""
    #using the following function instead of a switch case
    def complement_base(base):
        switcher = {
            'A': 'T',
            'T': 'A',
            'C': 'G',
            'G': 'C',
        }
        return switcher.get(base, "Error") #Error on default
    
    for letter in rev_seq:
        compl_seq += complement_base(letter)
    if len(compl_seq) < 50:
        print compl_seq
    
    o = open(args.outputf,"w")
    o.write(compl_seq)
    o.close()
