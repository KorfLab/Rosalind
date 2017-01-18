#!/usr/bin/env Python2.7

#gc_nick1.py
#uses memory for only last 2 steps, nearly instantaneous runtime
import argparse
  
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description = 
      """Determine the number of rabbits given number of months in which they 
      reproduce and a reproductive age of one month and the number of offspring
      pairs they produce.""")
    parser.add_argument("n", type=int, help="integer number of months")
    parser.add_argument("k", type=int, help="integer number of offspring pairs")
    args = parser.parse_args()
    n = args.n
    k = args.k
    
    a = [1,1]
    for i in xrange(1,n-1):
      b= a[1]
      a[1] = a[0] * k + a[1]
      a[0]=b
    print a[1]