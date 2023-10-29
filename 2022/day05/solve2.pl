#!/usr/bin/env perl
use v5.20;
use warnings;
use List::MoreUtils qw(before_incl);
#open my $file, '<', 'input-small.txt';
open my $file, '<', 'input-large.txt';
my @lines = <$file>;
my @header = before_incl { /1/ } @lines;
my ($num_stacks) = pop(@header) =~ /.*(\d+)/;
my @stacks = map [], 1 .. $num_stacks+1;
for my $line (reverse @header) {
    my @crates = $line =~/ ?.(.)./g;
    for (my $i = 0; $i < @crates; $i++) {
        my $val = $crates[$i];
        push @{$stacks[$i+1]}, $val unless $val eq ' ';
    }
}
for my $line (grep /move/, @lines) {
    my ($cnt, $from, $to) = $line =~ /move (\d+) from (\d+) to (\d+)/;
    my @tmp;
    for (1 .. $cnt) { push @tmp, pop @{$stacks[$from]} }
    push @{$stacks[$to]}, reverse @tmp;
}
say join '', map { pop @$_ } @stacks[1 .. $num_stacks];

# MCD - input-small.txt answer
# LVZPSTTCZ - input-large.txt answer

