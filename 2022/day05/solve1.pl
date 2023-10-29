#!/usr/bin/env perl
use v5.20;
use warnings;
use List::MoreUtils qw(before_incl);
open my $file, '<', 'input-large.txt';
#open my $file, '<', 'input-small.txt';
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
    for (1 .. $cnt) { push @{$stacks[$to]}, pop @{$stacks[$from]} }
}
say join '', map { pop @$_ } @stacks[1 .. $num_stacks];

# CMZ - input-small.txt answer
# MQTPGLLDN - input-large.txt anser

