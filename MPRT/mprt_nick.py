#!/usr/bin/env Python2.7
#mprt_nick.py
def get_Fasta(protName):
  #reruns the fasta file of a protein as a multiline string
  import urllib2
  #print "downloading " + protName + " with urllib2"
  url = "http://www.uniprot.org/uniprot/"+protName+".fasta"
  f = urllib2.urlopen(url).read()
  with open(protName+".fasta", "wb") as code:
    code.write(f)
  return protName+".fasta"

def process_fasta(fasta_str):
  from Bio import SeqIO
  record = SeqIO.read(fasta_str, "fasta")
  #print (record.seq)  # or print str(record.seq)  to get the string.
  return record
 
def find_glycosylation_motif(seq):
  import re
  #[XY] means "either X or Y" and {X} means "any amino acid except X." For example, the N-glycosylation motif is written as N{P}[ST]{P}.  
  return  [m.start() + 1 for m in re.finditer(r'N[^P][ST][^P]',seq)] 

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description = """Determine if a list of proteins have a motif""")
    parser.add_argument("ProtName", help="Protein names file to be checked for motif")
    parser.add_argument("outputf", nargs="?", help = "optional output file name", default = "outputf.txt")
    args = parser.parse_args()
    #process protein names
    prots = open(args.ProtName)
    o = open(args.outputf, 'w')
    for prot in prots:
      
      fasta =  get_Fasta(prot[0:6]) #passing only the first 6 chars stops redirect issues
      seq = str(process_fasta(fasta).seq)
      loci = find_glycosylation_motif(seq)
      if loci:
        o.write(prot + str(loci)[1:-1].replace(',','')+ "\n")  #removes brackets and commas from output string
    prots.close()
    o.close() 
    
