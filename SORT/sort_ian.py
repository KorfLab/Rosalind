import sys

class BED:
	def __init__(self, chr, beg, end):
		self.chr = chr
		self.beg = beg
		self.end = end
	def __repr__(self):
		return repr((self.chr, self.beg, self.end))

infile = open(sys.argv[1], "r")
bedfile = []
for line in infile:
	f = line.strip().split()	
	bedfile.append(BED(f[0], f[1], f[2]))


print("by chrom, beg, end")
beds = sorted(bedfile, key=lambda bed: (bed.chr, bed.beg, bed.end))
print(beds)


