#!/usr/bin/perl -w
use strict;

open IN,"<$ARGV[0]";
while (<IN>)  {
     s/T/U/g;
print "$_\n";
}
close IN;
