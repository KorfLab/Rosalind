#!/usr/bin/env Python2.7

#cub1_nick.py
from __future__ import division                #  deals with division problems
#    1. Given a file of coding sequences (ATG...Stop) create a codon usage table.
#    2.  Which 10 genes have the most canonical codon usage?
#    3.  Which 10 genes have the strangest codon usage?
#    4.  Follow up some of the genes from (3) and (4) in the WormBase genome browser to see if you find any patterns.

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


#fields: [triplet] [amino acid] [fraction of acid] [frequency: per thousand] ([number])
condonfrq = """\
UUU F 0.49 23.3 (260624)  UCU S 0.21 16.7 (187184)  UAU Y 0.56 17.5 (195860)  UGU C 0.55 11.2 (125864)
UUC F 0.51 23.9 (267710)  UCC S 0.13 10.6 (118939)  UAC Y 0.44 13.7 (153317)  UGC C 0.45  9.1 (101993)
UUA L 0.11  9.8 (110258)  UCA S 0.26 20.6 (230820)  UAA * 0.43  1.6 ( 17653)  UGA * 0.39  1.4 ( 15994)
UUG L 0.23 20.0 (224208)  UCG S 0.15 12.2 (136457)  UAG * 0.18  0.6 (  7245)  UGG W 1.00 11.1 (123925)

CUU L 0.25 21.2 (236968)  CCU P 0.18  8.8 ( 98666)  CAU H 0.61 14.1 (158091)  CGU R 0.21 11.2 (125440)
CUC L 0.17 14.8 (166037)  CCC P 0.09  4.4 ( 49300)  CAC H 0.39  9.2 (102747)  CGC R 0.10  5.1 ( 57149)
CUA L 0.09  7.9 ( 88086)  CCA P 0.53 26.1 (292755)  CAA Q 0.66 27.4 (306929)  CGA R 0.23 12.1 (135391)
CUG L 0.14 12.1 (135836)  CCG P 0.20  9.7 (108479)  CAG Q 0.34 14.4 (160920)  CGG R 0.09  4.7 ( 52902)

AUU I 0.53 32.2 (360846)  ACU T 0.32 18.9 (211659)  AAU N 0.62 30.2 (337956)  AGU S 0.15 12.1 (135726)
AUC I 0.31 18.9 (211592)  ACC T 0.18 10.4 (115954)  AAC N 0.38 18.3 (205008)  AGC S 0.10  8.4 ( 93596)
AUA I 0.16  9.5 (106074)  ACA T 0.34 20.0 (224368)  AAA K 0.59 37.5 (419559)  AGA R 0.29 15.4 (172826)
AUG M 1.00 26.1 (292175)  ACG T 0.15  8.9 ( 99441)  AAG K 0.41 25.8 (289397)  AGG R 0.08  4.0 ( 44270)

GUU V 0.39 24.1 (269560)  GCU A 0.36 22.4 (250829)  GAU D 0.68 35.8 (400841)  GGU G 0.20 10.9 (122203)
GUC V 0.22 13.6 (151950)  GCC A 0.20 12.6 (141585)  GAC D 0.32 17.1 (191126)  GGC G 0.12  6.7 ( 74950)
GUA V 0.16  9.8 (109949)  GCA A 0.31 19.8 (221831)  GAA E 0.62 40.8 (457346)  GGA G 0.59 31.7 (354969)
GUG V 0.23 14.3 (160677)  GCG A 0.13  8.2 ( 91816)  GAG E 0.38 24.5 (274607)  GGG G 0.08  4.4 ( 49363)"""
#source http://www.kazusa.or.jp/codon/cgi-bin/showcodon.cgi?species=6239&aa=1&style=N

#creates codontable for prot
def codontable():
    elem = codontabletxt.replace('\n',' ').split() #get an array of all words in the multiline string
    return {elem[x]:elem[x+1] for x in range(0,len(elem)-1,2)}

def fasta_to_dict(fasta_str):
  from Bio import SeqIO
  return {record.id:str(record.seq).replace('T','U') for record in SeqIO.parse(fasta_str, "fasta")}

def make_codon_usage_tb(rseq_dict):
    cd_2_a_tb = codontable()
    cctb = {}
    tt = 0
    for triplet in cd_2_a_tb:
      cctb[triplet]=0
    for pName, seq in rseq_dict.items():
      x=0
      tt += len(seq)/3  #increase total count of all codons
      while x+2<=len(seq):
        codon = seq[x:x+3]
        cctb[codon] += 1
        x += 3
    cftb = {trip:count/tt for trip, count in cctb.items()} #codon freq tb 
    return cctb, cftb, tt
def make_acid_usage_tb(rseq_dict):
    cd_2_a_tb = codontable()
    tt = 0
    actb = {}
    for triplet, acid in cd_2_a_tb.items():
      actb[acid]=0
    for pName, seq in rseq_dict.items():
      x=0
      tt += len(seq)/3
      while x+2<=len(seq):
        codon = seq[x:x+3]
        actb[cd_2_a_tb[codon]] += 1
        x += 3
    aftb = {acid:count/tt for acid, count in actb.items()} #codon freq tb
    return actb, aftb

def outputusagetbs(cctb, cftb, actb, aftb):
  out = 'Nick\'s CUB output: 1a. Codon Frequency Table'
  import math
  for codon, count in sorted(cctb.items()):
    out += '\n{} {:4.1f}'.format(codon, cftb[codon]*1000) #freq per 1000
    #logodd  p1
    try: 
      logodd = '{:.5f}'.format(math.log(cftb[codon]) - math.log(1-cftb[codon]))
    except ValueError:
      logodd = '{:>8}'.format('Error') 
    out += ' {} {:6d}'.format(logodd, count)
  out2 = 'Nick\'s CUB output: 1b. Acid Frequency Table'
  for acid, count in sorted(actb.items()):
    out2 += '\n{:4} {:4.1f}'.format(acid, aftb[acid]*1000) #freq per 1000
    try: 
      logodd = '{:.5f}'.format(math.log(aftb[acid]/(1-aftb[acid])))
    except ValueError:
      logodd = '{:>8}'.format('Error') 
    out2 += ' {} {:7d}'.format(logodd, count)
  return out, out2

def translate_from_dna(dnaSeq):
  return translate_from_rna(dnaSeq.replace('T','U'))
 
if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description = """Determine the codon usage of a genome
                                                  along with the amino acid usage""")
    parser.add_argument("RNAsequenceFile", help="genome fasta file")
    parser.add_argument("codonOutputF", nargs="?", help = "optional codon usage file name", default = "cdnUse.txt")
    parser.add_argument("acidOutputF", nargs="?", help = "optional acid usage file name", default = "acdUse.txt")
    args = parser.parse_args()
    #get RNA sequence
    g = open(args.RNAsequenceFile)
    rseq_dicti = fasta_to_dict(g)
    g.close()
    pseq_dicti = {}
    err_dicti = {}
    cdnuse_dicti = {}
    prot_db = {}
    cctb, cftb, tt = make_codon_usage_tb(rseq_dicti)
    actb, aftb = make_acid_usage_tb(rseq_dicti)    
    #output
    o = open(args.codonOutputF,"w")
    o2 = open(args.acidOutputF,"w")  
    cdOut, acOut = outputusagetbs(cctb,cftb,actb,aftb)
    o.write(cdOut)
    o.close()
    o2.write(acOut)
    o2.close()
        
