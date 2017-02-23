#!/usr/bin/env Python2.7

#grph_nick.py
def fasta_to_dict(fasta_str):
  from Bio import SeqIO
  return {record.id:str(record.seq) for record in SeqIO.parse(fasta_str, "fasta")}

def dict_to_grph(seq_dict):
  out = ''
  for id in seq_dict:
    sample = seq_dict[id][-3:]
    for id2 in seq_dict:
      if sample == seq_dict[id2][:3] and id != id2:
        out += id + " " + id2 +'\n'
  return out


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description = """Output a graph of 3 for a fasta file of sequences""")
    parser.add_argument("ProtName", help="fasta file input")
    parser.add_argument("outputf", nargs="?", help = "optional output file name", default = "outputf.txt")
    args = parser.parse_args()
    #process protein names
    f = open(args.ProtName)
    o = open(args.outputf, 'w')
    dicti =  fasta_to_dict(f)
    o.write(dict_to_grph(dicti))
    f.close()
    o.close()
    
