#!/usr/bin/env perl
use v5.20;
use warnings;
use List::Util qw(first sum);

sub score {
    my $letter = shift;
    return ord($letter) - ord('a') + 1 if $letter =~ /[a-z]/;
    return ord($letter) - ord('A') + 27;
}

open my $file, '<', 'input-small.txt';
#open my $file, '<', 'input-large.txt';
my $sum = 0;
while (my $sack = <$file>) {
    chomp $sack;
    my $items1 = substr $sack, 0, length($sack)/2;
    my $items2 = substr $sack, length($sack)/2;
    my %set1 = map { $_ => 1 } split //, $items1;
    $sum += score first { $set1{$_} } split //, $items2;
}
say $sum;

# 157 - input-small.txt answer
# 7742 - input-large.txt answer
