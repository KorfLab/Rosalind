#!/usr/bin/python3

#Given: k homozygous dominant individuals, m heterozygous individuals, and n homozygous
#recessive individuals

#Returns: probability that 2 randomly selected mating organisms will produce an individual
#having the dominant allele

import sys

try:
	fil = sys.argv[1]
except IndexError:
	sys.exit('Please enter input file as ARGV1.')
	
with open(fil) as infile:
	nums = infile.read().split()
	k, m, n = int(nums[0]), int(nums[1]), int(nums[2])

tot_pop = float(k + m + n)	#Total population

#Probability of picking 2 homozygous dominant individuals
pr_2_homdom = (k / tot_pop) * ((k-1) / (tot_pop-1))

#Probability of picking 1 homozygous dominant and 1 heterozygous individual
pr_1_homdom_1_het = 2 * (k / tot_pop) * (m / (tot_pop-1))

#Probability of picking 2 heterozygous individuals
pr_2_het = (m / tot_pop) * ((m-1) / (tot_pop-1))

#Probability of picking 1 homozygous recessive and 1 heterozygous individual
pr_1_homrec_1_het = 2 * (n / tot_pop) * (m / (tot_pop-1))

#Probability of picking 2 homozygous recessive individuals
pr_2_homrec = (n / tot_pop) * ((n-1) / (tot_pop-1))

#Probability of picking 1 homozygous dominant and 1 homozygous recessive individual
pr_1_homdom_1_homrec = 2 * (k / tot_pop) * (n / (tot_pop-1))

#Probability that 2 randomly picked organisms will produce offspring with dominant allele
pr_dom_off = 1*pr_2_homdom + 1*pr_1_homdom_1_het + (3/4.0)*pr_2_het + (1/2.0)*pr_1_homrec_1_het + 0*pr_2_homrec + 1*pr_1_homdom_1_homrec

print(pr_dom_off)
