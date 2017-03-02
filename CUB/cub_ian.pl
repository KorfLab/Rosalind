#!/usr/bin/perl
use strict;
use warnings 'FATAL' => 'all';
use FAlite;

die "$0 <CDS in FASTA>" unless @ARGV == 1;

## parse 1: global codon usage ##

open(my $fh1, $ARGV[0]) or die;
my $fasta = new FAlite($fh1);
my %c1;
my $total;
while (my $entry = $fasta->nextEntry) {
	my $seq = $entry->seq;
	next unless length($seq) > 1000;
	for (my $i = 0; $i < length($seq); $i += 3) {
		my $codon = substr($seq, $i, 3);
		$c1{$codon}++;
		$total++;
	}
}
close $fh1;

my %f1;
foreach my $codon (keys %c1) {
	$f1{$codon} = $c1{$codon} / $total;
}

## parse 2: comparisons ##

open(my $fh2, $ARGV[0]) or die;
$fasta = new FAlite($fh2);
while (my $entry = $fasta->nextEntry) {
	my $seq = $entry->seq;
	next unless length($seq) > 1000;	
	my ($id) = $entry->def =~ /^>(\S+)/;
	my %c2;
	my $tot;
	for (my $i = 0; $i < length($seq); $i += 3) {
		my $codon = substr($seq, $i, 3);
		$c2{$codon}++;
		$tot++;
	}
	
	my %f2;
	foreach my $codon (keys %c2) {
		$f2{$codon} = $c2{$codon} / $tot;
	}
	
	my $d = distance(\%f1, \%f2);
	print "$id\t$d\n";
	
}
close $fh2;

sub distance {
	my ($f1, $f2) = @_;
	my $d;
	foreach my $codon (keys %$f1) {
		$f2->{$codon} = 0 if not defined $f2->{$codon};
		$d += abs($f1->{$codon} - $f2->{$codon});
	}
	return $d;
}

__END__

Squares
F31B12.1a       0.000750890526100993	pic-1 phospholipase C
F31B12.1c       0.000784419606789881
ZK54.2a 0.00080945139765375	tps-1 Trehalose 6-Phosphate Synthase
F31B12.1e       0.000819934176603146
F31B12.1b       0.000828658858617719
C05C10.2b       0.000831503148033439	RNA helicase
C41A3.1b        0.000831561166003588	pks-1 PolyKetide Synthase
M03A8.2 0.000832261762180053	atg-2 (AuTophaGy (yeast Atg homolog))
C05C10.2a       0.000834471978647459
F31E3.4 0.000850725520442858	panl-2 poly-A RNAse
:
F23H12.4b       0.130393363949741	sqt-3 collagen
F54D7.6 0.132466073270497	rpl-41.1 ribosomal protein only 22 aa long
C34D4.11a       0.134708062611242	GRSP-3 low-complexity thing
F54D7.7 0.139475127036935	
C01B10.5b       0.148083022355751	HIL-7 66aa version of a histone...
C01B10.5a       0.157932766017144
E02A10.2c       0.164428373044466	grl-23 hedgehog shortest isoform
C01B10.5c       0.16954302093713
T24B8.3c        0.187227768860651	19aa protein...
C34D4.11b       0.24836993938678

Absolute value
M03A8.2	0.161056174944026
C05C10.2b	0.17038125199987
C05C10.2a	0.170573638790195
K11C4.5a	0.171236396459117
K11C4.5d	0.171551955822709
ZK54.2a	0.172213155706905
K11C4.5c	0.172797577462644
F31E3.4	0.173620730173122
F31B12.1a	0.175348557985314
T28F3.5a	0.177904029124184
:
Y38F2AL.12	1.52154412363187
F35C8.9	1.53084543127782
Y67H2A.10c	1.54434109400025
C34D4.11b	1.62584979287626
C33H5.13c	1.6325823945663
F54D7.6	1.66316447827326
F54D7.7	1.66316447827326
ZK381.62	1.70885646283438
W03F8.6d	1.75876588071815
T24B8.3c	1.79418525775574

Transcripts > 1000 nt (the weird ones have almost no introns!)
R09B5.5
K08D12.6
C03A7.4
T28H11.5
AC3.3
Y47D7A.15	1.22227260072345
C50F7.2	1.24625579019201
Y39B6A.1	1.26069299882961
T26C11.2	1.28588401032213
H39E23.3	1.33927762751792

I've stumbled upon something very strange. Genes with low intron content have weird codon usage bias.

