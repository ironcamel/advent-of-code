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
open my $file, '<', 'input-large.txt';
my @lines = <$file>;
my @moves = map [ /^(.) (\d+)/g ], @lines;
my $h_pos = { x => 0, y => 0 };
my $t_pos = { x => 0, y => 0 };
my $trail = { "0,0" => 1 };

for my $move (@moves) {
    p $move;
    my ($d, $cnt) = @$move;
    for (1 .. $cnt) {
        if    ($d eq 'R') { $h_pos->{x}++ }
        elsif ($d eq 'L') { $h_pos->{x}-- }
        elsif ($d eq 'U') { $h_pos->{y}++ }
        elsif ($d eq 'D') { $h_pos->{y}-- }
        next if is_touching($h_pos, $t_pos);
        if ($h_pos->{x} != $t_pos->{x}) {
            ($h_pos->{x} > $t_pos->{x}) ? $t_pos->{x}++ : $t_pos->{x}--;
        }
        if ($h_pos->{y} != $t_pos->{y}) {
            ($h_pos->{y} > $t_pos->{y}) ? $t_pos->{y}++ : $t_pos->{y}--;
        }
        #say $t_pos->{x} . ',' . $t_pos->{y};
        $trail->{$t_pos->{x} . ',' . $t_pos->{y}} = 1;
    }
}

p $trail;
say scalar %$trail;

sub is_touching {
    my ($h_pos, $t_pos) = @_;
    my $x_diff = abs($h_pos->{x} - $t_pos->{x});
    my $y_diff = abs($h_pos->{y} - $t_pos->{y});
    return $x_diff <= 1 && $y_diff <= 1;
}

# 13 - input-small.txt answer
# 5960 - input-large.txt answer
