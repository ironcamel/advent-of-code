#!/usr/bin/env perl
use v5.20;
use warnings;

#open my $file, '<', 'input-small.txt';
open my $file, '<', 'input-large.txt';
my $line = <$file>;
my @letters = split //, $line;
for (my $i = 0; $i < length $line; $i++) {
    say $i + 14 and exit if check(substr $line, $i, 14);
}

sub check {
    my ($s) = @_;
    my %set = map { $_ => 1 } split //, $s;
    return 14 == scalar %set;
}

__END__

mjqjpqmgbljsphdztnvjfqwrcgsmlb - 7
bvwbjplbgvbhsrlpgdmjqwftvncz - first marker after character 5
nppdvjthqldpwncqszvftbrmjlhg - first marker after character 6
nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg - first marker after character 10
zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw - first marker after character 11

# 19 - input-small answer
# 3256 - input-large.txt answer
