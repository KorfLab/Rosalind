#usr/bin/perl
# con_chen.pl by chen
use strict;
use warnings;
use FAlite;
use Data::Dumper;
use List::Util qw/max min/;

my @profile;
my $count = [];
my $seq;

open(my $in,"<$ARGV[0]") or die;
my $fasta = new FAlite($in);
while (my $entry = $fasta->nextEntry) {
	my $id = $entry->def;
	$seq = uc $entry->seq;
	my @seq = split("",$seq); 
	#profile:
	for (my $i = 0; $i < length($seq); $i++) {
		if    ($seq[$i] eq "A") {$count[0]->[$i]++}
		elsif ($seq[$i] eq "C") {$count[1]->[$i]++}
		elsif ($seq[$i] eq "T") {$count[2]->[$i]++}
		else                    {$count[3]->[$i]++} 
	}
}
print Dumper(@count);

#consensus:
for (my $i=0; $i < length($seq); $i++) {
	if    (max(@count->[$i]) == $count[0]->[$i]) {print "A\t"}
	elsif (max(@count->[$i]) == $count[1]->[$i]) {print "C\t"}
	elsif (max(@count->[$i]) == $count[2]->[$i]) {print "T\t"}
	else                                         {print "G\t"}
}
close $in;
