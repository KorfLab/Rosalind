#!/usr/bin/perl

use strict; use warnings;

my ($input1) = @ARGV;

die "usage: $0 <File>\n" unless @ARGV;

my $data; my $seq;
open (my $in1, "<", $input1) or die "Cannot read from $input1: $!\n";
while (my $line = <$in1>) {
	chomp($line);
	next if ($line =~ /^>/); # wont work if multiple fasta
	$seq .= $line;
}
close $in1;
$data = orf($seq, $data);
$data = orf(revcomp($seq), $data);

foreach my $orf (sort keys %{$data}) {
	print "$orf\n";
}

sub revcomp {
	my $seq = reverse($_[0]);
	$seq =~ tr/ACGT/TGCA/;
	return($seq);
}

sub orf {
	my ($seq0, $data) = @_;
	my (@beg, @end);
	my %pos;
	while ($seq0 =~ /A/g) {
		my $beg = length($`);
		my $next = $';
		next if $next !~ /^TG/;
		push (@{$pos{$beg % 3}{beg}}, $beg);
	}
	while ($seq0 =~ /T/g) {
		my $end = length($`);
		my $next = $';
		next unless $next =~ /^(AA|AG|GA)/;
		push (@{$pos{$end % 3}{end}}, $end);
	}
	foreach my $num (keys %pos) {
		next if not defined $pos{$num}{beg} or not defined $pos{$num}{end};
		my @beg = @{$pos{$num}{beg}};
		my @end = @{$pos{$num}{end}};
		
		my $j = 0; my $end = $end[$j];
		for (my $i = 0; $i < @beg; $i++) {
			my $beg = $beg[$i];
			while ($beg > $end and $j < @end-1) {
				$j ++; $end = $end[$j];
			}
			next if $beg > $end;
			my $seq = substr($seq0, $beg, $end - $beg);
			my $pro = "";
			for (my $k = 0; $k < length($seq); $k+= 3) {
				$pro .= translate(substr($seq, $k, 3));
			}
			$data->{$pro} = 1;
		}
	}
	return($data);
}


sub translate {
   my ($codon) = @_;
	$codon =~ tr/T/U/;
   my %table = (
      'UUU' => 'F', 'CUU' => 'L', 'AUU' => 'I', 'GUU' => 'V',
      'UUC' => 'F', 'CUC' => 'L', 'AUC' => 'I', 'GUC' => 'V',
      'UUA' => 'L', 'CUA' => 'L', 'AUA' => 'I', 'GUA' => 'V',
      'UUG' => 'L', 'CUG' => 'L', 'AUG' => 'M', 'GUG' => 'V',
      'UCU' => 'S', 'CCU' => 'P', 'ACU' => 'T', 'GCU' => 'A',
      'UCC' => 'S', 'CCC' => 'P', 'ACC' => 'T', 'GCC' => 'A',
      'UCA' => 'S', 'CCA' => 'P', 'ACA' => 'T', 'GCA' => 'A',
      'UCG' => 'S', 'CCG' => 'P', 'ACG' => 'T', 'GCG' => 'A',
      'UAU' => 'Y', 'CAU' => 'H', 'AAU' => 'N', 'GAU' => 'D',
      'UAC' => 'Y', 'CAC' => 'H', 'AAC' => 'N', 'GAC' => 'D',
      'UAA' => ' ', 'CAA' => 'Q', 'AAA' => 'K', 'GAA' => 'E',
      'UAG' => ' ', 'CAG' => 'Q', 'AAG' => 'K', 'GAG' => 'E',
      'UGU' => 'C', 'CGU' => 'R', 'AGU' => 'S', 'GGU' => 'G',
      'UGC' => 'C', 'CGC' => 'R', 'AGC' => 'S', 'GGC' => 'G',
      'UGA' => ' ', 'CGA' => 'R', 'AGA' => 'R', 'GGA' => 'G',
      'UGG' => 'W', 'CGG' => 'R', 'AGG' => 'R', 'GGG' => 'G'
   ); #stolen from other people

   my $prot = defined($table{$codon}) ? $table{$codon} : defined($table{uc($codon)}) ? $table{uc($codon)} : "-";
   return($prot);
}
