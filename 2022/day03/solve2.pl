#!/usr/bin/env perl
use v5.20;
use warnings;
use List::Util qw(first sum);
use List::MoreUtils qw(natatime);

sub score {
    my $letter = shift;
    return ord($letter) - ord('a') + 1 if $letter =~ /[a-z]/;
    return ord($letter) - ord('A') + 27;
}

#open my $file, '<', 'input-small.txt';
open my $file, '<', 'input-large.txt';
my @lines = <$file>;
chomp @lines;
my $sum = 0;
my $it = natatime 3, @lines;

while (my @group = $it->()) {
    my %set1 = map { $_ => 1 } split //, $group[0];
    my %set2 = map { $_ => 1 } grep { $set1{$_} } split //, $group[1];
    $sum += score first { $set2{$_} } split //, $group[2];
}
say $sum;

# 70 - input-small.txt answer
# 2276 - input-large.txt answer
