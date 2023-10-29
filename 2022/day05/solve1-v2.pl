#!/usr/bin/env perl
use v5.20;
use warnings;
use List::MoreUtils qw(part);

open my $file, '<', 'input-large.txt';
#open my $file, '<', 'input-small.txt';
my @lines = <$file>;
my $num_stacks = length($lines[0]) / 4;
my $i = 0;
my @stacks = map { /.(.)..?/g } grep { /\[/ } @lines;
@stacks = map [ grep /\w/, reverse @$_ ], part { $i++ % $num_stacks } @stacks;
for my $line (grep /move/, @lines) {
    my ($cnt, $from, $to) = $line =~ /move (\d+) from (\d+) to (\d+)/;
    for (1 .. $cnt) { push @{$stacks[$to-1]}, pop @{$stacks[$from-1]} }
}
print join '', map { pop @$_ } @stacks;

# CMZ - input-small.txt answer
# MQTPGLLDN - input-large.txt anser

