#!/usr/bin/env perl
use v5.20;
use warnings;
use List::Util qw(first sum);

#open my $file, '<', 'input-small.txt';
open my $file, '<', 'input-large.txt';

my @lines = <$file>;
chomp @lines;
my @found = grep check($_), @lines;
say scalar @found;

sub check {
    my $line = shift;
    my ($a1, $a2, $b1, $b2) = split /\W+/, $line;
    return 
        ($a1 >= $b1 && $a2 <= $b2)
        ||
        ($b1 >= $a1 && $b2 <= $a2);
}

# 2 - input-small.txt answer
# 528 - input-large.txt answer
