#!/usr/bin/env Python2.7

#fibd_nick1.py


#building an (unneeded) array of values
    
import argparse  
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description = 
      """Determine the number of rabbits given number of months in which they 
      reproduce and a reproductive age of one month and the number of months
      they live.""")
    parser.add_argument("n", type=int, help="integer number of months")
    parser.add_argument("m", type=int, help="integer number of months rabbits live")
    args = parser.parse_args()
    n = args.n
    m = args.m
    
    a = [0,0]
    y = [0,1]
    for i in xrange(2,n+1):
      y.extend([a[i-1]])
      dead = 0 
      if i-m >= 0: 
        dead = y[i-m]
      a.extend([a[i-1]+y[i-1]- dead])
    print a[n]+y[n]