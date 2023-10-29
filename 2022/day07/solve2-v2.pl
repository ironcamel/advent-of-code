#!/usr/bin/env perl
use v5.20;
use warnings;
use List::Util qw(first sum0);
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
    }
}

p $fs;

sub sum_dir {
    my ($ref, $sizes) = @_;
    delete $ref->{_parent};
    my $dir_sum = sum0 grep { not ref } values %$ref;
    my @children = grep { ref } values %$ref;
    for my $child (@children) {
        my ($child_size, $child_sizes) = sum_dir($child, $sizes);
        $dir_sum += $child_size;
    }
    push @$sizes, $dir_sum;
    return ($dir_sum, $sizes)
}

my ($size, $sizes) = sum_dir($fs, []);
my $unused_space = 70_000_000 - $size;
my $need = 3_000_0000 - $unused_space;
say first { $_ >= $need } sort { $a <=> $b } @$sizes;

# 24933642 - input-small.txt answer
# 6183184 - input-large.txt answer
