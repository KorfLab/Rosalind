#!/usr/bin/env Python2.7

#fibd_nick2.py


#actual recursion which is bad for runtime
#adults
def rab_a(n,m):
  if n < 2:
    return 0
  else:
    return rab_a(n-1,m) + rab_y(n-1,m) - rab_y(n-m,m)
#young
def rab_y(n,m):
  if n == 0:
    return 0
  elif n == 1:
    return 1
  else:
    return rab_a(n-1,m)
    
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
    result = rab_a(n,m) + rab_y(n,m)
    print result