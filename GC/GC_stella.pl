#!/usr/bin/perl

use strict; use warnings;

sanity_check();

my ($dnaFile) = @ARGV;

my ($perc, $name, $ref, $dna) = (-1);

open (my $in1, "<", $dnaFile) or die "Cannot read from $dnaFile: $!\n";

while (my $line = <$in1>) {
	chomp($line);
	if ($line =~ /^>/) {
		if (defined($dna)) {
			my $count = count($dna);
			$name = $ref   if $perc < $count;
			$perc = $count if $perc < $count;
			undef $dna;
		}
		($ref) = $line =~ /^>(\w+)$/;
	}
	else {
		$dna .= $line;
	}
		
}
close $in1;

if (defined($dna)) {
	my $count = count($dna);
	$name = $ref   if $perc < $count;
	$perc = $count if $perc < $count;
}

print "$name\n$perc\n";

sub count {
	my ($dna) = @_;
	my ($GC)  = $dna =~ tr/Gg/Gg/;
	($GC)    += $dna =~ tr/Cc/Cc/;
	my $total = length($dna);
	my $perc  = int($GC / $total * 100000000)/1000000;
	return($perc);
}


sub sanity_check {
	die "\nUsage: $0 <file input DNA like below>

#Sample Dataset

>Rosalind_6404
CCTGCGGAAGATCGGCACTAGAATAGCCAGAACCGTTTCTCTGAGGCTTCCGGCCTTCCC
TCCCACTAATAATTCTGAGG
>Rosalind_5959
CCATCGGTAGCGCATCCTTAGTCCAATTAAGTCCCTATCCAGGCGCTCCGCCGAAGGTCT
ATATCCATTTGTCAGCAGACACGC
>Rosalind_0808
CCACCCTCGTGGTATGGCTAGGCATTCAGGAACCGGAGAACGCTTCAGACCAGCCCGGAC
TGGGAACCTGCGGGCAGTAGGTGGAAT


#Sample Output

Rosalind_0808
60.919540\n\n" unless @ARGV;

}
