#!/usr/bin/env perl
use v5.20;
use warnings;
use List::Util qw(any sum);
use Data::Dumper;
$Data::Dumper::Terse = 1;
$Data::Dumper::Sortkeys = 1;

open my $infile, '<', 'input-small.txt'; 
#open my $infile, '<', 'input-large.txt'; 
my @lines = <$infile>;
chomp @lines;
my $sum = 0;
my @top_three;
my $elf = { sum => 0, bag => [] };

for my $cal (@lines) {
    if (length $cal) {
        push @{$elf->{bag}}, $cal;
    } else {
        $elf->{sum} = sum @{$elf->{bag}};
        if (@top_three < 3) {
            push @top_three, $elf;
        } elsif (any { $elf->{sum} > $_->{sum} } @top_three) {
            @top_three = sort { $b->{sum} <=> $a->{sum} } @top_three, $elf;
            pop @top_three;
        }
        #say Dumper $elf->{sum}, \@top_three;
        $elf = { sum => 0, bag => [] };
    }
}

say sum map $_->{sum}, @top_three;
# 45000 - small
# 210367 - large
