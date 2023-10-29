#!/usr/bin/env perl
use v5.20;
use warnings;
use List::Util qw(sum);

#open my $infile, '<', 'input-small.txt'; 
open my $infile, '<', 'input-large.txt'; 
my @lines = <$infile>;
chomp @lines;
my $max = 0;
my $sum = 0;

for my $cal (@lines) {
    if (length $cal) {
        $sum += $cal;
    } else {
        $max = $sum if $sum > $max;
        $sum = 0;
    }
}

say $max;
# 24000 - small
# 72478 - large
