#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use FAlite;
use Data::Dumper;

# sequence:
my @seq;
open(my $fh,"<$ARGV[0]") or die;
my $fasta = new FAlite($fh);
while (my $entry = $fasta->nextEntry) {
	my $id = $entry->def;
	my $seq = uc $entry->seq;
	push (@seq, $seq);
}
#print Dumper (@seq);
 
# profile initialize 0
my @nt = qw(A C G T);
my @count; 
for (my $i = 0; $i < length($seq[0]); $i++) {
	foreach my $nt (@nt) {
	$count[$i]{$nt} = 1;
	}	
}
#print Dumper (@count);	


# profile
foreach my $seq (@seq) {
	for (my $i = 0; $i < length($seq[0]); $i++) {
		my $nt = substr($seq, $i, 1);
		$count[$i]{$nt}++;
	}
}

# prob-observe:
my (@sum,@ave_observe);
for (my $i = 0; $i < length($seq[0]); $i++) {
	$sum[$i] = $count[$i]{A} + $count[$i]{C} + $count[$i]{G} + $count[$i]{T};	
	$ave_observe[$i] = [$count[$i]{A}/$sum[$i], $count[$i]{C}/$sum[$i], $count[$i]{G}/$sum[$i], $count[$i]{T}/$sum[$i]];
}

my %ave_Q = ( 
	A => [0.97, 0.01, 0.01, 0.01], 	a => [0.70, 0.10, 0.10, 0.10]
	C => [0.01, 0.97, 0.01, 0.01],	c => [0.10, 0.70, 0.10, 0.10],
	G => [0.01, 0.01, 0.97, 0.01],	g => [0.10, 0.10, 0.70, 0.10],
	T => [0.01, 0.01, 0.01, 0.97],	t => [0.10, 0.10, 0.10, 0.70],
	R => [0.49, 0.01, 0.49, 0.01],  r => [0.40, 0.10, 0.40, 0.10],
	Y => [0.01, 0.49, 0.01, 0.49], 	y => [0.10, 0.40, 0.10, 0.40],
	S => [0.01, 0.49, 0.49, 0.01], 	s => [0.10, 0.40, 0.40, 0.10],
	W => [0.49, 0.01, 0.01, 0.49], 	w => [0.40, 0.10, 0.10, 0.40],
	K => [0.01, 0.49, 0.01, 0.49], 	k => [0.10, 0.40, 0.10, 0.40],
	M => [0.49, 0.01, 0.49, 0.01],	m => [0.40, 0.10, 0.40, 0.10],
	B => [0.01, 0.33, 0.33, 0.33], 	b => [0.10, 0.30, 0.30, 0.30],
	D => [0.33, 0.33, 0.01, 0.33],  d => [0.30, 0.30, 0.10, 0.30],
	H => [0.33, 0.01, 0.33, 0.33], 	h => [0.30, 0.10, 0.30, 0.30],
	N => [0.25, 0.25, 0.25, 0.25], 
);
#print Dumper(%ave_Q);

my (@keys, @ratio);
my %hash;
my $cons;
for (my $i = 0; $i < length($seq[0]); $i++) {
	foreach my $key (keys %ave_Q) {
		$hash{$key} = value_d($ave_observe[$i], $ave_Q{$key});
	}
	@keys = sort { $hash{$b} <=> $hash{$a} } keys %hash;
	$cons .= $keys[0];
}
print $cons;


sub value_d {
	my(@P, @Q) = @_;
	for (my $j = 0; $j < 4; $j++) {
        	$P[$j] = $ave_observe[$j];
		@Q = values %ave_Q;
        	my $ratio = ((log($P[$j])/log(2)) - (log($Q[$j]) / (log(2)))) * $P[$j];
        	my $sum += $ratio;
       		return ($sum);
	}
}
