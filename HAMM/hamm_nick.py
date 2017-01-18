#!/usr/bin/env Python2.7

#hamm_nick.py

import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("DNAsequenceFile", help="DNA sequence file to be translated to RNA")
    
    parser.add_argument("outputf", nargs="?", help = "optional output file name", default = "outputf.txt")
    args = parser.parse_args()

    f = open(args.DNAsequenceFile,"r")
    #get first line
    dna1 = f.readline()
    dna1.rstrip()
    #get second line
    dna2 = f.readline()
    dna2.rstrip() 
    f.close()
    #iterate through the sequence counting differences
    hamm = 0
    for i in xrange (0,len(dna1)-1):
      if dna1[i] != dna2[i]:
        hamm += 1
    print hamm