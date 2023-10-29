#!/usr/bin/env perl
use v5.20;
use warnings;

open my $file, '<', 'input-large.txt';
#open my $file, '<', 'input-small.txt';
my @lines = <$file>;
chomp @lines;
my $sum = 0;
my %values = ( A => 1, B => 2, C => 3 );
my %choice = (
    A => { X => 'C', Y => 'A', Z => 'B' },
    B => { X => 'A', Y => 'B', Z => 'C' },
    C => { X => 'B', Y => 'C', Z => 'A' },
);
my %score = ( X => 0, Y => 3, Z => 6 );

for (@lines) {
    my ($p1, $p2) = split;
    $sum += $values{$choice{$p1}{$p2}} + $score{$p2};
}
say $sum;

__END__
# 12 - input-small.txt answer
# 11618 - input-large.txt answer

A - rock
B - paper
C - scissors

