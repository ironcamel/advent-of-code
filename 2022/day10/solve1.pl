#!/usr/bin/env perl
use v5.20;
use warnings;

use List::Util qw(sum0);
use Data::Dumper qw(Dumper);
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 1;

sub p {
#say Dumper @_;
}

#open my $file, '<', 'input-small.txt';
#open my $file, '<', 'input-small2.txt';
open my $file, '<', 'input-large.txt';
my @lines = <$file>;
my @cmds = map [ split ], @lines;
my $cycle = 1;
my $reg = 1;
my $signals = {};
for my $cmd (@cmds) {
    my ($op, $val) = @$cmd;
    if ($op eq 'noop') {
        record_signal($signals, $cycle, $reg);
        $cycle++;
    } else {
        record_signal($signals, $cycle, $reg);
        $cycle++;
        record_signal($signals, $cycle, $reg);
        $reg += $val;
        $cycle++;
    }
}

sub record_signal {
    my ($signals, $cycle, $reg) = @_;
    return if ($cycle + 20) % 40;
    $signals->{$cycle} = $reg * $cycle;
}

p $signals;
say sum0 values %$signals;

# 13140 - input-small2.txt answer
# 15020 - input-large.txt answer
