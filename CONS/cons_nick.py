#!/usr/bin/env Python2.7

#cons_nick.py

def fasta_to_array(fasta_str):
  from Bio import SeqIO
  return [str(record.seq) for record in SeqIO.parse(fasta_str, "fasta")]

def error_check_len(arr):  #make sure all seqs in array are the same length
  a = len(arr[0])
  for i in arr[1:]:
    if len(i) != a:
      return False
      break
  return True
      

def score(seq_arr):
  scores = []
  nucs = set()
  for i in xrange(len(seq_arr[0])):
    scores.append({})
    for seq in seq_arr:
      try:
        scores[i][seq[i]] += 1
      except KeyError:
        nucs.add(seq[i])
        scores[i][seq[i]] = 1
  return scores, nucs
        
def build_cons(scr):
  import operator
  cons = ''
  for i in xrange(len(scr)):
    cons += max(scr[i], key=scr[i].get)
  return cons

def out_score_tb(scr, nucs):
  out = ''
  for nuc in nucs:
    out += '\n' + nuc + ":"
    for i in xrange(len(scr)):
      try:  
        out += ' ' + str(scr[i][nuc])
      except KeyError:
        out += " 0"
  return out      
  
if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description = """Output the consesus sequence for a fasta file of sequences""")
    parser.add_argument("seqs", help="fasta file input")
    parser.add_argument("outputf", nargs="?", help = "optional output file name", default = "outputf.txt")
    args = parser.parse_args()
    
    f = open(args.seqs)
    o = open(args.outputf, 'w')
    seq_arr =  fasta_to_array(f)
    assert error_check_len(seq_arr), "Incorrect input data"
    scores_arr, nucset = score(seq_arr)
    o.write(build_cons(scores_arr))
    o.write(out_score_tb(scores_arr, nucset))
    f.close()
    o.close()