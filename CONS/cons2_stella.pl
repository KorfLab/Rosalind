#!/usr/bin/perl
# works and fast but super badly coded
# Groups (from lowest to highest). X is fraction of that nucleotide in that position
# Group 1: 0 <= x <= 1/4
# Group 2: 1/4 < x <= 1/3;
# Group 3: 1/3 < x <= 1/2;
# Group 4: 1/2 < x <= 1;
# Consider only nucleotide in the highest group.
# if highest group is 3 and there's only 1 nucleotide in there, then lowercase that nucleotide
# but if there are 2 nucleotide then use lowercase IUPAC
# if there are 3 nucleotides, then if they are exactly 1/3 each, uppercase IUPAC, otherwise lowercase I$

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
   A g Y m N T t S
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
	if ($line =~ />/) {
		$ref = $line;
		$ref =~ s/>//;
		$pos = 0;
		$total ++;
	}
	else {
		for (my $i = 0; $i < length($line); $i++) {
			my $nuc = substr(uc($line), $i, 1);
			if (not grep(/$nuc/i, @nuc)) {
				print "Undefined nuc $nuc\n";
				push(@nuc, $nuc);
			}
			$data{$pos}{$nuc} ++;
			$pos ++;
		}
	}
}
close $in1;

my $header;
my $body;
foreach my $nuc (@nuc[0..@nuc-1]) {
	$body .= "$nuc:";
	foreach my $pos (sort {$a <=> $b} keys %data) {
		$data{$pos}{$nuc} = 0 if not defined $data{$pos}{$nuc};
		$body .= " $data{$pos}{$nuc}";
		next if $nuc ne $nuc[0];
		my $prev;
		foreach my $nuc2 (sort {$data{$pos}{$b} <=> $data{$pos}{$a}} keys %{$data{$pos}}) {
			my $value = $data{$pos}{$nuc2};
			if ($value > 0.5 * $total) { #A = 100/100; a = 51/100
				$header .= $value == $total ? $nuc2 : lc($nuc2); 
				#print "$pos: 1. $header\n";
				last;
			}
			elsif ($value > $total / 3) {# a = 35/100, t = 34/100;
				if (defined $prev and $prev =~ /^TWO/) {
					my ($nuc1) = $prev =~ /TWO;(.+)$/;
					my $nuc3 = get_iupac("$nuc1$nuc2");
					$header .= $value * 2 == $total ? $nuc3 : lc($nuc3); 
					#print "$pos: 2. $header\n"; 
					last;
				}
				else {
					$prev .= "TWO;$nuc2";
				}
			}
			elsif (defined $prev and $prev =~ /^TWO/) {
				my ($nuc1) = $prev =~ /TWO;(.+)$/;
				$nuc1 = get_iupac("$nuc1");
				$header .= lc($nuc1); last;
			}
			elsif ($value > $total / 4) {
				if (defined $prev and $prev =~ /^THREE/) {
					if ($prev =~ /^\w+;.;.$/) {
						my ($nuc1) = $prev =~ /THREE;(.+)$/; $nuc1 =~ s/;//g;
						my $nuc3 = get_iupac("$nuc1$nuc2");
						$header .= $value * 3 == $total ? $nuc3 : lc($nuc3); 
						print "$pos: 3. $header\n"; 
						last;
					}
					else {
						$prev .= ";$nuc2";
					}
				}
				else {
					$prev .= "THREE;$nuc2";
				}
			}
			elsif (defined $prev and $prev =~ /^THREE/) {
				my ($nuc1) = $prev =~ /THREE;(.+)$/; $nuc1 =~ s/;//g;
				$nuc1 = get_iupac("$nuc1");
				$header .= lc($nuc1); last;
			}
			else {
				$header .= "N"; last;
			}
		}
	}
	$body .= "\n";
}

print "   " . join(" ", split("", $header)) . "\n$body";

sub get_iupac {
	my ($nuc) = @_;
	return $nuc if $nuc =~ /^.$/;
	return "R" if $nuc =~ /[AG][AG]/;
	return "Y" if $nuc =~ /[CT][CT]/;
	return "S" if $nuc =~ /[GC][GC]/;
	return "W" if $nuc =~ /[AT][AT]/;
	return "K" if $nuc =~ /[GT][GT]/;
	return "M" if $nuc =~ /[AC][AC]/;
	return "B" if $nuc =~ /[CGT][CGT][CGT]/;
	return "D" if $nuc =~ /[AGT][AGT][AGT]/;
	return "H" if $nuc =~ /[ACT][ACT][ACT]/;
	return "V" if $nuc =~ /[ACG][ACG][ACG]/;
	return "N" if $nuc =~ /[ACGT][ACGT][ACGT][ACGT]/;
}
