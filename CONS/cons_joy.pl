#!/usr/bin/perl
# cons_joy.pl
use strict;
use warnings;

die "usage: cons_joy.pl <DNA strings of equal length in FASTA format>\n" if @ARGV == 0;

my $profile = { 
	'A' => [], 
	'C' => [], 
	'G' => [], 
	'T' => [],
}; 

my @dna;
my $current_seq;
while (<>) {
	chomp;
	if ($_ =~ /^>/) {
		$current_seq++;
	} else { 
		$dna[$current_seq - 1] .= $_;
	}

}

foreach my $letter (keys %{$profile}) {
	@{$profile->{$letter}} = (0) x length($dna[0]); 
}

foreach my $seq (@dna) {
	for (my $i = 0; $i < length($seq); $i++) {	
	 		my $nt = substr($seq, $i, 1);
			$profile->{$nt}[$i]++
	}
}

my $con_seq;
for (my $i = 0; $i < @{$profile->{A}}; $i++) {
	my $con_nt;
	my $max_count = 0;
	foreach my $letter (keys %{$profile}) {
		if ($profile->{$letter}[$i] >= $max_count) {
			$max_count = $profile->{$letter}[$i];
			$con_nt = $letter;
		}
	}
	$con_seq .= $con_nt;
}

print $con_seq, "\n";

my @keys = qw(A C G T);
foreach my $key (@keys) {
	print "$key: @{$profile->{$key}}\n";
}