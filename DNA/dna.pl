#!/usr/bin/perl 

open IN,"<$ARGV[0]";
while (<IN>) {
my $coutA= s/A/#/g;
my $coutG= s/G/#/g;
my $coutC= s/C/#/g;
my $coutT= s/T/#/g;
print " $coutA $coutC $coutG $coutT\n";
}
close IN;
