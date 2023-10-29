#!/usr/bin/env perl
# Recursive BFS algorithm.
use v5.20;
use warnings;
use subs qw(p);

use List::Util qw(sum0);
use Data::Dumper qw(Dumper);
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 1;

#open my $file, '<', 'input-small.txt';
open my $file, '<', 'input-large.txt';
my @lines = <$file>;
chomp @lines;
my $marks = [ map [ split // ], @lines ];
my $max_x = @{$marks->[0]} - 1;
my $max_y = @$marks - 1;
my $graph = {};

for (my $x = 0; $x <= $max_x; $x++) {
    for (my $y = 0; $y <= $max_y; $y++) {
        my $key = key($x, $y);
        my $node = $graph->{$key} = { x => $x, y => $y, key => $key };
        my $mark = $marks->[$y][$x];
        $node->{mark} = $mark;
        $node->{h} = ord $mark;
        if ($mark eq 'S') {
            $node->{h} = ord 'a';
            $node->{is_start} = 1;
            $node->{distance} = 0;
        } elsif ($mark eq 'E') {
            $node->{h} = ord 'z';
            $node->{is_end} = 1;
        }
    }
}

my ($start) = grep { $_->{is_start} } values %$graph;
bfs([$start]);

sub bfs {
    my ($nodes) = @_;
    my $node = shift @$nodes;
    return unless $node;
    #say "$node->{key} d:$node->{distance} v:" . ($node->{v} ? 1 : 0);
    if (not $node->{v}) {
        if ($node->{is_end}) { say "best distance: $node->{distance}" and exit }
        my @children = kids($graph, $node);
        for my $child (@children) { $child->{distance} //= $node->{distance} + 1 }
        push @$nodes, @children;
        #p [ map $_->{key}, @$nodes ];
    }
    $node->{v} = 1;
    @_ = ($nodes);
    goto &bfs;
    #bfs($nodes);
}

sub kids {
    my ($graph, $node) = @_;
    my ($x, $y) = @{$node}{qw(x y)};
    return (
        grep { not $_->{v} }
        grep { $_ and $node->{h} >= ($_->{h} - 1) }
        map { $graph->{key(@$_)} }
        [$x, $y+1], [$x, $y-1], [$x+1, $y], [$x-1, $y]
    );
}

sub key { "$_[0],$_[1]" }

sub p {
    say Dumper @_;
}

# 31 - input-small.txt answer
# 383 - input-large.txt answer

