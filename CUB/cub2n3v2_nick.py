#!/usr/bin/env Python2.7

#cub2n3v2_nick.py   Uses frequencies instead of logodds
from __future__ import division                #  deals with division problems
import cub1_nick
#    1. Given a file of coding sequences (ATG...Stop) create a codon usage table.
#####2.  Which 10 genes have the most canonical codon usage?
#    3.  Which 10 genes have the strangest codon usage?
#    4.  Follow up some of the genes from (3) and (4) in the WormBase genome browser to see if you find any patterns.


def score_gene_by_cdn(seq, cdnTb):  #given a sequence and the codon frequency table to compare it to
    thisGeneCC = {}
    absDist = 0
    for triplet in cdnTb:
      thisGeneCC[triplet] = 1 #pseudocount
    x = 0
    tt = len(seq)/3  #total count of codons
    while x+2<=len(seq):
      triplet = seq[x:x+3]
      thisGeneCC[triplet] += 1
      x += 3
    for triplet in cdnTb:
      freq = thisGeneCC[triplet]/tt
      absDist += abs(cdnTb[triplet] - freq) 
    return absDist / len(cdnTb) 

def score_gene_by_acd(seq, acdTb):  #given a sequence and the codon frequency table to compare it to
    thisGeneAC = {}
    absDist = 0
    cd_2_a_tb = cub1_nick.codontable()
    for acid in acdTb:
      thisGeneAC[acid] = 1
    x = 0
    tt = len(seq)/3  #total count of amino acids
    while x+2<=len(seq):
      triplet = seq[x:x+3]
      thisGeneAC[cd_2_a_tb[triplet]] += 1
      x += 3
    for acid in acdTb:
      freq = thisGeneAC[acid]/tt
      absDist += abs(acdTb[acid] - freq) 
    return absDist / len(acdTb)
         
def getTb(filename):
    from numpy import genfromtxt
    tb = genfromtxt(filename, skip_header=1,  dtype=None)
    #[triplet freq*1000 logodds count]
    return {i[0]:i[1]/1000 for i in tb}  

def sort_genes(fasta, AorC, tbF):
    genes = cub1_nick.fasta_to_dict(fasta)
    freqs = getTb(tbF)
    geneLog = {}
    for name, seq in genes.items():
      if AorC == 'c':
        geneLog[name] = score_gene_by_cdn(seq,freqs)
      else:
        geneLog[name] = score_gene_by_acd(seq,freqs)
    sGeneLog = sorted(geneLog, key=geneLog.get)  
    return [(name,geneLog[name]) for name in sGeneLog]

def output(olist, outf):
  o = open(outf,"w")
  o.write('10 Most Canonical')
  for i in xrange(10):
    o.write('\n' + olist[i][0] + ' ' + str(olist[i][1]))
  o.write('\n10 Least Canonical')
  for i in xrange(1,11):
    o.write('\n' + olist[-i][0] + ' ' + str(olist[-i][1]))
  o.close()

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description = """Determine the genes of a genome that have most and least
                                                   canonical codon and amino acid usage""")
    parser.add_argument("sequenceFile", help="genome fasta file")
    parser.add_argument("codonInputF", nargs="?", help = "optional codon usage file name", default = "cdnUse.txt")
    parser.add_argument("acidInputF", nargs="?", help = "optional acid usage file name", default = "acdUse.txt")
    args = parser.parse_args()
    #Codons
    # get sequences and get them sorted
    codonGList = sort_genes(args.sequenceFile,'c',args.codonInputF)      
    #output
    codonoutf = args.codonInputF[:(len(args.codonInputF)-4)]+'CurGeneResultv2.txt'
    output(codonGList,codonoutf)
    
    #Same again but for Amino Acids
    acidGList = sort_genes(args.sequenceFile,'a',args.acidInputF)
    acidoutf = args.acidInputF[:(len(args.acidInputF)-4)]+'CurGeneResultv2.txt'
    output(acidGList,acidoutf)
      