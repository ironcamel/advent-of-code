#!/usr/bin/env perl
use v5.20;
use warnings;

#open my $file, '<', 'input-small.txt';
#open my $file, '<', 'input-small2.txt';
open my $file, '<', 'input-large.txt';
my @lines = <$file>;
my @cmds = map [ split ], @lines;
my $cycle = 1;
my $reg = 1;

for my $cmd (@cmds) {
    my ($op, $val) = @$cmd;
    if ($op eq 'noop') {
        draw($cycle, $reg);
        $cycle++;
    } else {
        draw($cycle, $reg);
        $cycle++;
        draw($cycle, $reg);
        $reg += $val;
        $cycle++;
    }
}

sub draw {
    my ($cycle, $reg) = @_;
    my $pixel = ($cycle - 1) % 40;
    print(($reg >= $pixel - 1 and $reg <= $pixel + 1) ? '#' : '.');
    print "\n" if $cycle % 40 == 0;
}

# EFUGLPAP - input-large.txt answer
