#checksum!

import argparse
parser = argparse.ArgumentParser(description = """uniquely identify a file""")
parser.add_argument("file", help="input file")
args = parser.parse_args()
g = open(args.file)
sum = 0
for line in g:
  linesum = 0
  for char in line:
    linesum += ord(char)
  sum += linesum % 256 
g.close()
print sum