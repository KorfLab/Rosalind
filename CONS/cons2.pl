#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use FAlite;
use Getopt::Std;
use vars qw($opt_a $opt_k $opt_r $opt_s $opt_p $opt_x);
getopts('akrsxp:');

die "
usage: $0 [options] <fasta file>
options:
  -a         score w/ sum of absolute differences
  -k         score w/ Kullback-Leibler distance
  -r         score w/ sum of square root of differences
  -s         score w/ sum of squared differences
  -x         score via simulation...
  -p <float> pseudocount (recommended for K-L distance)
\n" unless @ARGV;

# read sequences
my @seq;
open(my $fh, $ARGV[0]) or die;
my $fasta = new FAlite($fh);
while (my $entry = $fasta->nextEntry) {
	push @seq, $entry->seq;
}

# initialize 2D matrix with pseudocount
my @count;
my $pseudo = $opt_p ? $opt_p : 0;
my @nt = qw(A C G T);
for (my $i = 0; $i < length($seq[0]); $i++) {
	foreach my $nt (@nt) {
		$count[$i]{$nt} = $pseudo;
	}
}

# count all nucleotides
foreach my $seq (@seq) {	
	for (my $i = 0; $i < length($seq); $i++) {
		my $nt = substr($seq, $i, 1);
		$count[$i]{$nt}++;
	}
}

# convert to frequencies
my @freq;
my $total = @seq + 4 * $pseudo;
for (my $i = 0; $i < @count; $i++) {
	foreach my $nt (@nt) {
		$freq[$i]{$nt} = $count[$i]{$nt} / $total;
	}
}

# target frequencies
my %t = (
	'A' => [0.97, 0.01, 0.01, 0.01], 'a' => [0.70, 0.10, 0.10, 0.10],
	'C' => [0.01, 0.97, 0.01, 0.01], 'c' => [0.10, 0.70, 0.10, 0.10],
	'G' => [0.01, 0.01, 0.97, 0.01], 'g' => [0.10, 0.10, 0.70, 0.10],
	'T' => [0.01, 0.01, 0.01, 0.97], 't' => [0.10, 0.10, 0.10, 0.70],
	'R' => [0.49, 0.01, 0.49, 0.01], 'r' => [0.40, 0.10, 0.40, 0.10],
	'Y' => [0.01, 0.49, 0.01, 0.49], 'y' => [0.10, 0.40, 0.10, 0.40],
	'M' => [0.49, 0.49, 0.01, 0.01], 'm' => [0.40, 0.40, 0.10, 0.10],
	'K' => [0.01, 0.01, 0.49, 0.49], 'k' => [0.10, 0.10, 0.40, 0.40],
	'W' => [0.49, 0.01, 0.01, 0.49], 'w' => [0.40, 0.10, 0.10, 0.40],
	'S' => [0.01, 0.49, 0.49, 0.01], 's' => [0.10, 0.40, 0.40, 0.10],
	'B' => [0.01, 0.33, 0.33, 0.33], 'b' => [0.10, 0.30, 0.30, 0.30],
	'D' => [0.33, 0.01, 0.33, 0.33], 'd' => [0.30, 0.10, 0.30, 0.30],
	'H' => [0.33, 0.33, 0.01, 0.33], 'h' => [0.30, 0.30, 0.10, 0.30],
	'V' => [0.33, 0.33, 0.33, 0.01], 'v' => [0.30, 0.30, 0.30, 0.10],
	'N' => [0.25, 0.25, 0.25, 0.25],
);

# determine consensus as closest match between observed and target
for (my $i = 0; $i < @freq; $i++) {
	my $min_d = 1e9;
	my $min_nt;
	my $p = [$freq[$i]{A}, $freq[$i]{C}, $freq[$i]{G}, $freq[$i]{T}];
	my $c = [$count[$i]{A}, $count[$i]{C}, $count[$i]{G}, $count[$i]{T}];
	foreach my $nt (keys %t) {
		my $q = $t{$nt};
		my $d;
		if    ($opt_k) {$d = dkl($p, $q)}
		elsif ($opt_a) {$d = dsum($p, $q)}
		elsif ($opt_s) {$d = dsquare($p, $q)}
		elsif ($opt_r) {$d = dsqrt($p, $q)}
		elsif ($opt_x) {$d = dsim($c, $q, scalar(@seq))}
		else {die "must choose one of -a, -k, -r, -s, -x\n"}
		if ($d < $min_d) {
			$min_d = $d;
			$min_nt = $nt;
		}
	}
	print STDERR "$min_nt\n";
	print $min_nt;
}
print "\n"; 

# functions

sub dsim {
	my ($c, $p, $d) = @_;
	my $limit = 1e4;
	my @v = ($p->[0], $p->[0] + $p->[1], $p->[0] + $p->[1] + $p->[2]);
	my %pcount;
	for (my $i = 0; $i < $limit; $i++) {
		my %n = (A => 0, C => 0, G => 0, T => 0);
		for (my $j = 0; $j < $d; $j++) {
			my $rnd = rand(1);
			my $nt;
			if    ($rnd < $v[0]) {$nt = 'A'}
			elsif ($rnd < $v[1]) {$nt = 'C'}
			elsif ($rnd < $v[2]) {$nt = 'G'}
			else                 {$nt = 'T'}
			$n{$nt}++;
		}
		$pcount{"$n{A}:$n{C}:$n{G}:$n{T}"}++;
	}
	my $search = "$c->[0]:$c->[1]:$c->[2]:$c->[3]";
	if (defined $pcount{$search}) {return $limit - $pcount{$search}}
	else                          {return $limit}
}

sub dkl {
	my ($p, $q) = @_;
	my $sum = 0;
	for (my $i = 0; $i < @$p; $i++) {
		$sum += $p->[$i] * log($p->[$i] / $q->[$i]);
	}
	return $sum;
}

sub dsum {
	my ($p, $q) = @_;
	my $sum = 0;
	for (my $i = 0; $i < @$p; $i++) {
		$sum += abs($p->[$i] - $q->[$i]);
	}
	return $sum;
}

sub dsquare {
	my ($p, $q) = @_;
	my $sum = 0;
	for (my $i = 0; $i < @$p; $i++) {
		$sum += ($p->[$i] - $q->[$i]) ** 2;
	}
	return $sum;
}

sub dsqrt {
	my ($p, $q) = @_;
	my $sum = 0;
	for (my $i = 0; $i < @$p; $i++) {
		$sum += sqrt(abs($p->[$i] - $q->[$i]));
	}
	return $sum;
}
