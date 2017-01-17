#!/usr/bin/perl
#iprb_kat.pl by kat
use warnings; use strict;

die "usage: iprb_kat.pl <no. homozygous dom><no. heterozygous><no. homozyg. rec>
returns probability that 2 random organisms produce offspring with dominant allele.\n"
unless @ARGV == 3;

my($homo_dom, $hetero, $homo_rec) = @ARGV;
my $pop_total = $homo_dom + $hetero + $homo_rec;


#probabilities (Parent 1): 
#DD = ($homo_dom / $pop_total);
#Dd = ($hetero / $pop_total);
#dd = ($homo_rec / $pop_total);


#probability for dominant offspring with homo_dom parent 1
my $prob_DD = ($homo_dom / $pop_total);

#probability for dominant offspring with heterozygous parent 1
my $prob_Dd = ($hetero/$pop_total) * (($homo_dom/($pop_total - 1))
+ (0.75)*($hetero - 1)/($pop_total - 1) + (0.5)*($homo_rec/($pop_total - 1)));

#probability for dom offspring with homo_rec parent 1
my $prob_dd = ($homo_rec/$pop_total)*(($homo_dom/($pop_total-1)) + (0.5)*($hetero/($pop_total-1)));

#Add together 3 cases for final probability
my $final_prob = $prob_DD + $prob_Dd + $prob_dd;
print $final_prob, "\n";





