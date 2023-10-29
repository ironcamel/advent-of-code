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

#open my $file, '<', 'foo.txt';
#open my $file, '<', 'input-small.txt';
open my $file, '<', 'input-large.txt';
my @lines = <$file>;
chomp @lines;
shift @lines;
my $fs = {};

do_cmd(\@lines, $fs);

sub do_cmd {
    my ($lines, $fs) = @_;
    my $cmd = shift @$lines;
    $cmd =~ s/^\$ *//;
    my @cmd = split ' ', $cmd;
    my $next_dir;

    if ($cmd[0] eq 'ls') {
        my @items;
        while (@$lines and $lines[0] !~ /\$/) {
            push @items, shift @$lines;
        }
        for my $item (@items) {
            if ($item =~ /^dir/) {
                my (undef, $dir) = split ' ', $item;
                $fs->{$dir} ||= {};
                $fs->{$dir}{_parent} = $fs;
            } else {
                my ($size, $file) = split ' ', $item;
                $fs->{$file} = $size;
            }
        }
    } elsif ($cmd[0] eq 'cd') {
        my $dir_name = $cmd[1];
        if ($dir_name eq '..') {
            $fs = $fs->{_parent};
        } else {
            $fs = $fs->{$dir_name};
        }
    }
    if (@$lines) {
        @_ = ($lines, $fs);
        goto &do_cmd;
        #do_cmd($lines, $fs);
    }
}

p $fs;

my $sum = 0;

sub sum_dir {
    my ($ref) = @_;
    delete $ref->{_parent};
    my $dir_sum = sum0 grep { not ref } values %$ref;
    my @refs = grep { ref } values %$ref;
    for my $child (@refs) {
        $dir_sum += sum_dir($child);
    }
    $sum += $dir_sum if $dir_sum <= 100_000;
    return $dir_sum;
}

sum_dir($fs, 0);

say $sum;

# 95437 - input-small.txt answer
# 1084134 - input-large.txt answer
