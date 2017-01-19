#!/usr/bin/env Python2.7

#subs_nick2.py
#pulls input from commandline
import argparse  
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description = 
      """Determine the number of rabbits given number of months in which they 
      reproduce and a reproductive age of one month and the number of months
      they live.""")
    parser.add_argument("s", help="sequence")
    parser.add_argument("t", help="subsequence")
    args = parser.parse_args()
    s = args.s
    t = args.t
    
    loci = ""
    for i in xrange(0,len(s)-len(t)+1):
      if s[i] == t[0]:
        if s[i:i+len(t)] == t:
          loci += str(i+1) + " "
    print loci