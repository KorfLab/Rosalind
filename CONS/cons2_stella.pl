#!/usr/bin/perl
# Groups (from lowest to highest). X is fraction of that nucleotide in that position
# Range of group is hardcoded. May consider non hardcoded in future.
# Group 1: 0 <= x <= 1/4
# Group 2: 1/4 < x <= 1/3;
# Group 3: 1/3 < x <= 1/2;
# Group 4: 1/2 < x <= 1;
# Consider only nucleotide in the highest group.
# if highest group is 3 and there's only 1 nucleotide in there, then lowercase that nucleotide
# but if there are 2 nucleotide then use lowercase IUPAC
# if there are 3 nucleotides, then if they are exactly 1/3 each, uppercase IUPAC, otherwise lowercase I$
# gaps is included in total number of sequence but isn't considered in consensus

# out of 9 sequences:
# A C G T
# 9 0 0 0 = A
# 5 0 0 4 = a
# 4 1 0 4 = w (a or t)
# 3 1 1 4 = t (since A is 1/3, it's group 2, while T is 4/9 so group 3. Only T is considered.)
# 3 3 0 3 = H (A/C/T)
# 3 2 1 3 = w (a or t) - since A and T are group 2 (3/9) while C and G are group 1

use strict; use warnings;

my ($input1) = @ARGV;

my @breaks = (1/4, 1/3, 1/2, 1); # hardcoded. Can be changed.

die "usage: $0 <fasta file>

>s1
AGCAATTG
>s2
AGTCCTTC
>s3
AGCAGTTG
>s4
AGTCTTTC
>s5
AGCAATTG
>s6
AATCCTTC
>s7
ACCGGTAG
>s8
ATTTTTCC

Sample Output
AgYmNTtS
A: 8 1 0 3 2 0 1 0
C: 0 1 4 3 2 0 1 4
G: 0 5 0 1 2 0 0 4
T: 0 1 4 1 2 8 6 0

" unless @ARGV;

my %data;
my ($ref, $pos, $total);
my @nuc = qw(A C G T);
open (my $in1, "<", $input1) or die "Cannot read from $input1: $!\n";
while (my $line = <$in1>) {
	chomp($line);
	if ($line =~ /^>/) {
		$pos = 0;
		$total ++;
	}
	else {
		for (my $i = 0; $i < length($line); $i++) {
			my $nuc = substr(uc($line), $i, 1);
			push(@nuc, $nuc) if (not grep(/$nuc/i, @nuc));
			$data{$pos}{$nuc} ++;
			$pos ++;
		}
	}
}
close $in1;

foreach my $pos (sort {$a <=> $b} keys %data) {
	my ($final, $lastgroup, $lc_check);
	foreach my $nuc (sort {$data{$pos}{$b} <=> $data{$pos}{$a}} keys %{$data{$pos}}) {
		my $value = $data{$pos}{$nuc} / $total;
		my $group = @breaks;
		while ($group > 1 and $value <= $breaks[$group-2]) {
			$group --;
		}
		last if (defined $lastgroup and $lastgroup != $group);
		$final .= $nuc;
		$lc_check = 1 if $value < $breaks[$group-1];
		$lastgroup = $group;
	}
	$final = defined $lc_check ? lc(get_iupac($final)) : get_iupac($final);
	print "$final";
}
print "\n";
foreach my $nuc (@nuc[0..@nuc-1]) {
	print  "$nuc:";
	foreach my $pos (sort {$a <=> $b} keys %data) {
		$data{$pos}{$nuc} = 0 if not defined $data{$pos}{$nuc};
		print  " $data{$pos}{$nuc}";
		next if $nuc ne $nuc[0];
	}
	print  "\n";
}

sub get_iupac {
   my ($nuc) = @_;
   $nuc =~ s/-//g;
   $nuc =~ s/N//g;
   $nuc =~ s/\.//g;
   return $nuc if $nuc =~ /^[ACGT]$/;
   return "R" if $nuc =~ /^[AG]{2,2}$/;
   return "Y" if $nuc =~ /^[CT]{2,2}$/;
   return "S" if $nuc =~ /^[GC]{2,2}$/;
   return "W" if $nuc =~ /^[AT]{2,2}$/;
   return "K" if $nuc =~ /^[GT]{2,2}$/;
   return "M" if $nuc =~ /^[AC]{2,2}$/;
   return "B" if $nuc =~ /^[CGT]{3,3}$/;
   return "D" if $nuc =~ /^[AGT]{3,3}$/;
   return "H" if $nuc =~ /^[ACT]{3,3}$/;
   return "V" if $nuc =~ /^[ACG]{3,3}$/;
   return "N" if $nuc =~ /^[ACGT]{4,4}$/;
}
