#!/usr/bin/env perl
use v5.20;
use warnings;

use List::Util qw(sum0);
use Data::Dumper qw(Dumper);
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 1;

sub p {
    say Dumper @_;
}

#open my $file, '<', 'input-small.txt';
open my $file, '<', 'input-large.txt';
my @lines = <$file>;
chomp @lines;
my @trees = map [ split // ], @lines;
my $max_i = @trees - 1;
my $max_j = @{$trees[0]} - 1;
my %graph;

scan([0 .. $max_i], [0 .. $max_j]);
scan([0 .. $max_i], [reverse 0 .. $max_j]);
scanr([0 .. $max_j], [0 .. $max_i]);
scanr([0 .. $max_j], [reverse 0 .. $max_i]);

sub scan {
    my ($range_i, $range_j) = @_;
    for my $i (@$range_i) {
        my $tallest = 0;
        for my $j (@$range_j) {
            my $key = "$i,$j";
            my $h = $trees[$i][$j];
            if ($i == 0 or $i == $max_i or $j == 0 or $j == $max_j) {
                $graph{$key} = 1;
            }
            if ($h > $tallest) {
                $graph{$key} = 1;
                $tallest = $h;
            }
        }
    }
}

sub scanr {
    my ($range_j, $range_i) = @_;
    for my $j (@$range_j) {
        my $tallest = 0;
        for my $i (@$range_i) {
            my $key = "$i,$j";
            my $h = $trees[$i][$j];
            if ($i == 0 or $i == $max_i or $j == 0 or $j == $max_j) {
                $graph{$key} = 1;
            }
            if ($h > $tallest) {
                $graph{$key} = 1;
                $tallest = $h;
            }
        }
    }
}

say scalar %graph;

# 21 - input-small.txt answer
# 1719 - input-large.txt answer
