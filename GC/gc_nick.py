#!/usr/bin/env Python2.7

#gc_nick.py

import argparse
def calcGC(seq):
  gcCount = 0
  for j in seq:
    if j.upper() == "C" or j.upper() == "G":
      gcCount += 1
  gc = float(gcCount) / len(seq) * 100
  return gc
  
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("FastaFile", help="FASTA file to find largest GC content")
    args = parser.parse_args()

    f = open(args.FastaFile,"r")
    d = []
    name = ''
    seq = ''
    while True:
      line = f.readline()
      if line== '':
        f.close()
        print "reached end of file"
        break
      elif line[0] == ">":
        #if next entry, store the previous 
        if seq != '':
          d.append([name,seq])
          seq = ''
        #get the name of the new entry
        name = line[1:]
      else:
        seq += line.rstrip()   #line breaks get removed
    for e in d: 
      e.extend([calcGC(e[1])])  #accesses the seq of each entry and
                                #appends the gc calculation to entry  
    d.sort(key=lambda entry: entry[2], reverse=True) #sort list by decreasing gc
    print d[0][0] + "%.6f" % d[0][2]
        

      