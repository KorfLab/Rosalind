use strict; use warnings;

my ($input1) = @ARGV;

die "usage: $0 <fasta file>

Example:
>Rosalind_1
ATCCAGCT
>Rosalind_2
GGGCAACT
>Rosalind_3
ATGGATCT
>Rosalind_4
AAGCAACC
>Rosalind_5
TTGGAACT
>Rosalind_6
ATGCCATT
>Rosalind_7
ATGGCACT

Sample Output
ATGCAACT
A: 5 1 0 0 5 5 0 0
C: 0 0 1 4 2 0 6 1
G: 1 1 6 3 0 1 0 0
T: 1 5 0 0 0 1 1 6

" unless @ARGV;

my %data;
my ($ref, $pos);
my @nuc = qw(A C G T);
open (my $in1, "<", $input1) or die "Cannot read from $input1: $!\n";
while (my $line = <$in1>) {
	chomp($line);
	if ($line =~ /^>/) {
		$ref = $line =~ /^>(.+)$/;
		$pos = 0;
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
		foreach my $nuc (sort {$data{$pos}{$b} <=> $data{$pos}{$a}} keys %{$data{$pos}}) {
			$header .= $nuc;
			last;
		}
	}
	$body .= "\n";
}
print "$header\n$body";
