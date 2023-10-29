#!/usr/bin/env perl
use v5.20;
use warnings;

#open my $file, '<', 'input-small.txt';
#open my $file, '<', 'input-small2.txt';
open my $file, '<', 'input-large.txt';
my @lines = <$file>;
my @moves = map [ /^(.) (\d+)/g ], @lines;
my $pos = [ map +{ x => 0, y => 0 }, 0 .. 9 ];
my $trail = { "0,0" => 1 };

for my $move (@moves) {
    my ($d, $cnt) = @$move;
    for (1 .. $cnt) {
        for my $i (0 .. 8) {
            my $h_pos = $pos->[$i];
            my $t_pos = $pos->[$i+1];
            if ($i == 0) {
                if    ($d eq 'R') { $h_pos->{x}++ }
                elsif ($d eq 'L') { $h_pos->{x}-- }
                elsif ($d eq 'U') { $h_pos->{y}++ }
                elsif ($d eq 'D') { $h_pos->{y}-- }
            }
            next if is_touching($h_pos, $t_pos);
            if ($h_pos->{x} != $t_pos->{x}) {
                ($h_pos->{x} > $t_pos->{x}) ? $t_pos->{x}++ : $t_pos->{x}--;
            }
            if ($h_pos->{y} != $t_pos->{y}) {
                ($h_pos->{y} > $t_pos->{y}) ? $t_pos->{y}++ : $t_pos->{y}--;
            }
            if ($i == 8) {
                $trail->{$t_pos->{x} . ',' . $t_pos->{y}} = 1;
            }
        }
    }
}

say scalar %$trail;

sub is_touching {
    my ($h_pos, $t_pos) = @_;
    my $x_diff = abs($h_pos->{x} - $t_pos->{x});
    my $y_diff = abs($h_pos->{y} - $t_pos->{y});
    return $x_diff <= 1 && $y_diff <= 1;
}

# 1 - input-small.txt answer
# 36 - input-small.txt answer
# 2327 - input-large.txt answer

