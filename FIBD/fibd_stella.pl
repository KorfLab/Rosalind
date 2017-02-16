#!/usr/bin/perl

use strict; use warnings; use bigint;

my ($input1) = @ARGV;

die "
usage: $0 <file input>

Sample Dataset

6 3
Sample Output

4

\n" unless @ARGV;
open (my $in1, "<", $input1) or die "Cannot read from $input1: $!\n";
while (my $line = <$in1>) {
   chomp($line);
   my ($n, $m) = split(" ", $line);
   my %pop;
   for (my $i = 0; $i <= $m; $i++) {
      $pop{$i} = 0;
   }
   $pop{0} = 1;
   for (my $month = 1; $month <= $n; $month++) {
      my $pair = 0;
      foreach my $age (sort {$b <=> $a} keys %pop) {
         $pop{$age} = $pop{$age-1} if $age > 0;
         $pop{0} = 0 if $age == 1;
         if ($age > $m) {
            $pop{$age} = 0;
         }
         $pair += $pop{$age};
      }
      foreach my $age (sort {$a <=> $b} keys %pop) {
         if ($age > 1) {
            $pop{0} += $pop{$age};
         }
      }
      print "$pair\n" if $month == $n;
   }
}
close $in1;

