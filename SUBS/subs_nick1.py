#!/usr/bin/env Python2.7

#subs_nick1.py
#pulls input from file

import argparse  
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description = 
      """Determine the number of rabbits given number of months in which they 
      reproduce and a reproductive age of one month and the number of months
      they live.""")
    parser.add_argument("sequencesFile", help="file with sequence on 1st line followed by subsequence on the 2nd")
    args = parser.parse_args()
    f = open(args.sequencesFile,"r")
    
    s = f.readline().rstrip()
    t = f.readline().rstrip()
    f.close()
    
    loci = ""
    for i in xrange(0,len(s)-len(t)+1):
      if s[i] == t[0]:
        if s[i:i+len(t)] == t:
          loci += str(i+1) + " "
    print loci