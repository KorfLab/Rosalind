
class BED:
	def __init__(self, chr, beg, end):
		self.chr = chr
		self.beg = beg
		self.end = end
	def __repr__(self):
		return repr((self.chr, self.beg, self.end))
	def length(self):
		return 'CBA'.index(self.end) - (self.beg)


bedfile = [
	BED('A', 100, 300),
	BED('B', 100, 200),
	BED('A', 100, 200),
	BED('A', 200, 300),
]

print("by chrom")
beds = sorted(bedfile, key=lambda bed: (bed.chr, bed.beg, bed.end))
print(beds)
