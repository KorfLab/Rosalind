#!/usr/bin/env Python2.7
#orf_nick.py
import prot_nick 

def findStarts(seq,dna):
  #sequence, bool whether dna or not
  if dna:
    t = "ATG"
  else:
    t = "AUG"
  loci = []
  for i in xrange(0,len(seq)-2):
      if seq[i] == "A":
        if seq[i:i+3] == t:
          loci.extend([i])
  return loci

def getorfs(seq,dna):
  orfs = []
  for i in findStarts(seq,dna): 
    if dna:
      orfs.extend([prot_nick.translate_from_dna(seq[i:])])
    else: 
      orfs.extend([prot_nick.translate_from_rna(seq[i:])])
  return orfs
  
def readFASTA(Ffile):  
  f = open(Ffile,'r')
  d = []
  name = ''
  seq = ''
  while True:
    line = f.readline()
    if line== '':
      f.close()
      d.append([name,seq])
      break
    elif line[0] == ">":
      #if next entry, store the previous 
      if seq != '':
        d.append([name,seq])
        print name
        seq = ''
      #get the name of the new entry
      name = line[1:].rstrip()
    else:
      seq += line.rstrip()   #line breaks get removed 
  return d

def get_proteins_from_dna_fasta(Ffile):
  g = readFASTA(Ffile)
  output = {i[0]:(getorfs(i[1],True)) for i in g}
  return output
  
def get_proteins_from_rna_fasta(Ffile):
  g = readFASTA(Ffile)
  output = {i[0]:(getorfs(i[1],False)) for i in g} 
  
if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description = "Return proteins for each ORF in a given FASTA file")
    parser.add_argument("FastaFile", help="FASTA file to find largest GC content")
    args = parser.parse_args()
    out = get_proteins_from_dna_fasta(args.FastaFile)
    
    for e in out:
      print e
      for i in out[e]:
        print i                                                      