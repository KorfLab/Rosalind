#!/usr/bin/env Python2.7

#fib_nick2.py

#actual recursion which is bad for runtime
def rab(n,k):
  if n == 0:
    return 0
  elif n == 1:
    return 1
  else:
    return rab(n-2,k) * k + rab(n-1,k)
    
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
    print rab(n,k)
