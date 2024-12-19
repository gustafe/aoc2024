#! /usr/bin/env perl
# Advent of Code 2024 Day 19 - Linen Layout - part 1 / part 2 / complete solution
# https://adventofcode.com/2024/day/19
# https://gerikson.com/files/AoC2024/UNLICENSE
###########################################################
use Modern::Perl '2015';
# useful modules
use List::Util qw/sum max/;
use Data::Dump qw/dump/;
use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;
sub sec_to_hms;

my $start_time = [gettimeofday];
#### INIT - load input data from file into array

my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my %towels = map { $_ => 1 } split( /,\s+/, $input[0] );
my @targets;
for ( my $idx = 2; $idx <= $#input; $idx++ ) {
    push @targets, $input[$idx];
}
if ($testing) {
    dump \%towels;
    dump \@targets;

}
my $max_towel_length = max( map { length($_) } keys %towels );
say "max length: $max_towel_length" if $testing;
my $ans;
my @matching;
for my $target (@targets) {
    my @Map = split( //, $target );
    push my @queue, [ -1, -1 ];
SEARCH: while (@queue) {
        no warnings 'uninitialized';
        my $curr = pop @queue;
        if ( $curr->[1] == $#Map ) {    # reached end
            push @matching, $target;
            $ans->{1}++;
            last SEARCH;
        }
        my $start = $curr->[1] + 1;

        # try to move
        for my $towel ( keys %towels ) {
            if (join( '', @Map[ $start .. $start + length($towel) - 1 ] ) eq $towel )
            {
                push @queue, [ $start, $start + length($towel) - 1 ];
            }
        }
    }
}

# part 2

my %memo;
# structure of recursion credit /u/musifter:
# https://old.reddit.com/r/adventofcode/comments/1hhlb8g/2024_day_19_solutions/m2s8bg6/
sub count_matches {
    my ($str) = @_;
    return $memo{$str} if $memo{$str};
    return $memo{$str} = 1 if $str eq '';

    my $ret = 0;
    for my $towel ( keys %towels ) {
        my $new_str = $str;
        if ( substr( $new_str, 0, length($towel) ) eq $towel ) {
            $ret += count_matches( substr( $new_str, length($towel) ) );
        }
    }
    $memo{$str} = $ret;
    return $ret;
}

for my $pattern (@matching) {
    say $pattern if $testing;
    my $res = count_matches($pattern);
    say $res if $testing;
    $ans->{2} += $res;
}
### FINALIZE - tests and run time
is( $ans->{1}, 276,             "Part 1: $ans->{1}" );
is( $ans->{2}, 681226908011510, "Part 2: $ans->{2}" );

done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}


###########################################################

=pod

=head3 Day 19: Linen Layout

=encoding utf8

Part 1 was simple enough, I just used DFS as usual this year. For part
2 I copped out and found a nice solution for the recursion logic in
the subreddit. Credit in source.

Score: 1

Leaderboard completion time: 03m16s

=cut

