#!/usr/bin/env Python2.7

#prot_nick.py


import argparse 
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("ProteinCodeFile", help="File containing codons")
    parser.add_argument("RNAsequenceFile", help="RNA sequence file to be translated to protein")
    parser.add_argument("outputf", nargs="?", help = "optional output file name", default = "outputf.txt")
    args = parser.parse_args()
#creates codontable for prot
    codontable = ""
    f = open(args.ProteinCodeFile,"r")
    elem = []
    for line in f:
      elem.extend(line.split())
    f.close()
    codons = {elem[x]:elem[x+1] for x in range(0,len(elem)-1,2)}
#get DNA sequence
    g = open(args.RNAsequenceFile)
    rnaSeq = g.readline().rstrip()
    g.close()
    
    
    x = 0
    stopReached = False
    protSeq = ''
    
    while x+2<= len(rnaSeq):
      codon = rnaSeq[x:x+3]
      acid = codons.get(codon, "Error")
      if acid == 'Stop':
        print "Stop Reached!"
        break
      elif acid == 'Error':
        print "Error reached!"
        break
      protSeq += acid
      x += 3
    o = open(args.outputf,"w")  
    o.write(protSeq)
    o.close()
    
        