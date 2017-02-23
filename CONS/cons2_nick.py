#!/usr/bin/env Python2.7

#cons2_nick.py
#Let's complicate this shit
def ambsets(tie):
  if tie == 2:
    return {
      'M':set(['A','C']),
      'R':set(['A','G']),
      'W':set(['A','T']),
      'S':set(['C','G']),
      'Y':set(['C','T']),
      'K':set(['G','T'])  
    }
  elif tie == 3:
    return {
      'V':set(['A','C','G']),
      'H':set(['A','C','T']),
      'D':set(['A','G','T']),
      'B':set(['C','G','T'])
    }
  else: #tie == 4
    return {'N':set(['A','C','T','G'])}  

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
        
def build_cons(scr, tmx):
  tol = 1
  cons = ''  
  for i in xrange(len(scr)):
    #determine consc (consesus character)
    consc = ''
    sortNuc = sorted(scr[i], key=scr[i].get, reverse=True)
    maxv = scr[i][sortNuc[0]]
    if maxv == tmx:
      consc =  sortNuc[0]
    elif maxv > tmx/2:
      consc =  sortNuc[0].lower()
    else:
      j = len(sortNuc)
      while consc == '' and j > 1:   #j represents number of nucleotides in a tie
        if maxv - scr[i][sortNuc[j-1]] < tol: #check for significant nucleotides tie  
          asets =  ambsets(j)  #get the corresponding ambiguity sets
          for x in asets:
            if asets[x].issuperset(sortNuc[:j]):
              if tmx/j - maxv < 1:
                consc = x 
              else:
                consc = x.lower()
        j -= 1            
#     elif maxv == scr[i][sortNuc[1]]:  #at least 2 nucleotides tie
#       if maxv == scr[i][sortNuc[3]]:  #4 nucleotides tie
#         consc = 'N'
#       elif maxv == scr[i][sortNuc[2]]: #3 nucleotides tie
#         asets =  ambsets(3)  #get the ambiguity sets
#         for x in asets:
#           if asets[x].issuperset(sortNuc[:3]):
#             consc = x
#       else: #only 2 nucleotides tie
#         asets = ambsets(2)
#         for x in asets:
#           if asets[x].issuperset(sortNuc[:2]):
#             consc = x                
    cons += consc   
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
    totmax = len(seq_arr)
    scores_arr, nucset = score(seq_arr)
    o.write(build_cons(scores_arr,totmax))
    o.write(out_score_tb(scores_arr, nucset))
    f.close()
    o.close()