#!/usr/lib/python2.7

# sorter_sam.py

import sys, operator

try:
	infile = open(sys.argv[1], "r")
except IndexError:
	sys.exit("Specify infile as ARGV1.")
	
# variables and data structures
bed_db = {}

chr_db = {}
begin_db = {}
end_db = {}
length_db = {}
name = 0

for line in infile:
	name += 1
	splitline = line.strip().split("\t")
	
	bed_db[name] = [splitline[0], splitline[1], splitline[2]]
	
	chr_db[name] = splitline[0]
	begin_db[name] = splitline[1]
	end_db[name] = splitline[2]
	length_db[name] = int(splitline[2])-int(splitline[1])

# sort by chromosome
if sys.argv[2] == "chromosome":
	sorted_chr = sorted(chr_db, key=chr_db.get)
	for x in sorted_chr:
		print chr_db[x] + "\t" + begin_db[x] + "\t" + end_db[x]
		
# sort by length
if sys.argv[2] == "length":
	sorted_chr = sorted(length_db, key=length_db.get)
	for x in sorted_chr:
		print chr_db[x] + "\t" + begin_db[x] + "\t" + end_db[x]

# sort by chrom, then beg, then end
if sys.argv[2] == "complex":
	sorted_chr = sorted(bed_db, key=lambda k: (bed_db[k][0], bed_db[k][1], bed_db[k][2]))
#	print sorted_chr
	for x in sorted_chr:
		print chr_db[x] + "\t" + begin_db[x] + "\t" + end_db[x]
