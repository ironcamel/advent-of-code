#!/usr/bin/env perl
use v5.20;
use warnings;

use List::Util qw(max);
use Data::Dumper qw(Dumper);
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 1;

sub p {
    say Dumper @_;
}

open my $file, '<', 'input-small.txt';
#open my $file, '<', 'input-large.txt';
my @lines = <$file>;
chomp @lines;
my @trees = map [ split // ], @lines;
my $max_i = @trees - 1;
my $max_j = @{$trees[0]} - 1;
my %graph;

scan([1 .. $max_i-1], [1 .. $max_j-1]);

sub scan {
    my ($range_i, $range_j) = @_;
    for my $i (@$range_i) {
        my $tallest = 0;
        for my $j (@$range_j) {
            my $key = "$i,$j";
            my $h = $trees[$i][$j];
            my $cnt1 = 0;
            for my $k ($j+1 .. $max_j) { $cnt1++; last if ($trees[$i][$k] >= $h) }
            my $cnt2 = 0;
            for my $k (reverse 0 .. $j-1) { $cnt2++; last if ($trees[$i][$k] >= $h) }
            my $cnt3 = 0;
            for my $k ($i+1 .. $max_i) { $cnt3++; last if ($trees[$k][$j] >= $h) }
            my $cnt4 = 0;
            for my $k (reverse 0 .. $i-1) { $cnt4++; last if ($trees[$k][$j] >= $h) }
            $graph{$key} = $cnt1 * $cnt2 * $cnt3 * $cnt4;
        }
    }
}

say max values %graph;

# 8 - input-small.txt answer
# 590824 - input-large.txt answer

