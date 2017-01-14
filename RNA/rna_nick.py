#!/usr/bin/env Python2.7

#rna_nick.py

import argparse
DNA_seq = " "
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("DNAsequence", help="DNA sequence to be translated to RNA")

    args = parser.parse_args()

    DNA_seq = args.DNAsequence
    RNA_seq = DNA_seq.replace("T","U")

    print RNA_seq
    
