#!/usr/bin/env perl
use v5.20;
use warnings;

#open my $file, '<', 'input-small.txt';
open my $file, '<', 'input-large.txt';
my $line = <$file>;
my @letters = split //, $line;
for (my $i = 0; $i < length $line; $i++) {
    say $i + 4 and exit if check(substr $line, $i, 4);
}

sub check {
    my ($s) = @_;
    my %set = map { $_ => 1 } split //, $s;
    return 4 == scalar %set;
}

__END__

mjqjpqmgbljsphdztnvjfqwrcgsmlb - 7
bvwbjplbgvbhsrlpgdmjqwftvncz - first marker after character 5
nppdvjthqldpwncqszvftbrmjlhg - first marker after character 6
nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg - first marker after character 10
zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw - first marker after character 11

# 7 - input-small answer
# 1855 - input-large.txt answer
