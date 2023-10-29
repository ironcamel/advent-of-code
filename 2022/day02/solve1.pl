#!/usr/bin/env perl
use v5.20;
use warnings;

open my $file, '<', 'input-large.txt';
my @lines = <$file>;
chomp @lines;
my $sum = 0;
my %values = ( X => 1, Y => 2, Z => 3 );
my %score = (
    A => { X => 3, Y => 6, Z => 0 },
    B => { X => 0, Y => 3, Z => 6 },
    C => { X => 6, Y => 0, Z => 3 },
);
for (@lines) {
    my ($p1, $p2) = split;
    $sum += $values{$p2} + $score{$p1}{$p2};
}
say $sum;

# 15 - small input answer
# 12772 - large input answer
