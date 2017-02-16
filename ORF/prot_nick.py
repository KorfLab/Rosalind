#!/usr/bin/env Python2.7

#prot_nick.py

#modularized version of prot
codontabletxt = """\
UUU F      CUU L      AUU I      GUU V
UUC F      CUC L      AUC I      GUC V
UUA L      CUA L      AUA I      GUA V
UUG L      CUG L      AUG M      GUG V
UCU S      CCU P      ACU T      GCU A
UCC S      CCC P      ACC T      GCC A
UCA S      CCA P      ACA T      GCA A
UCG S      CCG P      ACG T      GCG A
UAU Y      CAU H      AAU N      GAU D
UAC Y      CAC H      AAC N      GAC D
UAA Stop   CAA Q      AAA K      GAA E
UAG Stop   CAG Q      AAG K      GAG E
UGU C      CGU R      AGU S      GGU G
UGC C      CGC R      AGC S      GGC G
UGA Stop   CGA R      AGA R      GGA G
UGG W      CGG R      AGG R      GGG G"""


#creates codontable for prot
def codontable():
    elem = codontabletxt.replace('\n',' ').split() #get an array of all words in the multiline string
    return {elem[x]:elem[x+1] for x in range(0,len(elem)-1,2)}
#uses the codontable to build up a first protein string   
def translate_from_rna(rnaSeq):    
    x = 0
    stopReached = False
    protSeq = ''
    cdtb = codontable()
    while x+2<= len(rnaSeq):
      codon = rnaSeq[x:x+3]
      acid = cdtb.get(codon, "Error")
      if acid == 'Stop':
        break
      elif acid == 'Error':
        print "Error reached!"
        break
      protSeq += acid
      x += 3
    return protSeq
def translate_from_dna(dnaSeq):
  return translate_from_rna(dnaSeq.replace('T','U'))
 
if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description = """Determine the protein sequence given an RNA sequence.
                                                  Can be used as a module for both RNA and DNA""")
    parser.add_argument("RNAsequenceFile", help="RNA sequence file to be translated to protein")
    parser.add_argument("outputf", nargs="?", help = "optional output file name", default = "outputf.txt")
    args = parser.parse_args()
    #get RNA sequence
    g = open(args.RNAsequenceFile)
    rnaSeq = g.readline().rstrip()
    g.close()
    
    #translate
    protSequence = translate_from_rna(rnaSeq)    
    #output
    o = open(args.outputf,"w")  
    o.write(protSequence)
    o.close()
    
        