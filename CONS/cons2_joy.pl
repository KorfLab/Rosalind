#!/usr/bin/perl
# cons2_joy.pl
use strict;
use warnings;
use Data::Dumper;

die "usage: cons2_joy.pl <DNA strings of equal length in FASTA format>\n" if @ARGV == 0;

my $parameter = {
	'sh' => [98, 0.5], 
	'sl' => [70, 10],
	'dh' => [49, 1],
	'dl' => [35, 15],
	'th' => [33, 1],
	'tl' => [30, 10],
	'n'  => [25],
};	
my $model = generate_model($parameter);

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

my $profile;
foreach my $seq (@dna) {
	for (my $i = 0; $i < length($seq); $i++) {	
	 		my $nt = substr($seq, $i, 1);
			$profile->[$i]{$nt}++
	}
}

my @keys = qw(A C G T);
for (my $i = 0; $i < length($dna[0]); $i++) {
	foreach my $letter (@keys) {
		if (not defined $profile->[$i]{$letter}) {
			$profile->[$i]{$letter} = 0.02; 
		} else {
			$profile->[$i]{$letter} = 0.02 + $profile->[$i]{$letter} / $current_seq;
		}
	}
}

my $con_seq;
for (my $i = 0; $i < length($dna[0]); $i++) {
	my $con_nt;
	my $max_score = 0;
	foreach my $symbol (keys %{$model}) {
		my $current_score = kldist ($profile->[$i], $model->{$symbol});
		
		if ($current_score >= $max_score) {
			$max_score = $current_score;
			$con_nt = $symbol;
		}
	}
	$con_seq .= $con_nt;
}
print $con_seq, "\n";


sub generate_model {
	my ($parameter) = @_; 
	my $model;
	my @keys = qw(A C G T);
	my $keys2 = { 
				'A' => ['A'],
				'C' => ['C'],
				'G' => ['G'],
				'T' => ['T'],
				'R' => ['A', 'G'],
				'Y' => ['C', 'T'],
				'S' => ['C', 'G'],
				'W' => ['A', 'T'],
				'K' => ['G', 'T'],
				'M' => ['A', 'C'],
				'B' => ['C', 'G', 'T'],
				'V' => ['A', 'C', 'G'],
				'D' => ['A', 'G', 'T'],
				'H' => ['A', 'C', 'T'],
};

	
	foreach my $symbol (keys $keys2) {
		my @state;
	
		if (@{$keys2->{$symbol}} > 2) {
			@state = ('th', 'tl');
		} elsif (@{$keys2->{$symbol}} > 1) {
			@state = ('dh', 'dl');
		} elsif (@{$keys2->{$symbol}} > 0) {
			@state = ('sh', 'sl');		
		}
		foreach my $letter (@keys) {
			$model->{$symbol}{$letter} = $parameter->{$state[0]}[1];
			$model->{lc($symbol)}{$letter} = $parameter->{$state[1]}[1];
		}
		foreach my $value (@{$keys2->{$symbol}}) {
			$model->{$symbol}{$value} = $parameter->{$state[0]}[0];
			$model->{lc($symbol)}{$value} = $parameter->{$state[1]}[0];			
		}
	}
	
	foreach my $letter (@keys) {
		$model->{'N'}{$letter} = $parameter->{'n'}[0];
	}
 	
 	return($model);
}

sub kldist {
	my ($obs, $model) = @_; 
	my @keys = qw(A C G T);
	my $total_score;
	
	foreach my $letter (@keys) {
		my $score = $obs->{$letter} * log($obs->{$letter} / $model->{$letter}) / log(2);
		$total_score += $score;
	}
	
	return(-$total_score);
}


