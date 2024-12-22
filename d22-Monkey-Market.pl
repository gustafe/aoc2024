#! /usr/bin/env perl
# Advent of Code 2024 Day 22 - Monkey Market - complete solution
# https://adventofcode.com/2024/day/22
# https://gerikson.com/files/AoC2024/UNLICENSE
###########################################################
use Modern::Perl '2015';

# useful modules
use List::Util qw/sum pairs max/;
use Data::Dump qw/dump/;
use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;
sub sec_to_hms;

my $start_time = [gettimeofday];
#### INIT - load input data from file into array

my $testing = 0;
my @input;
my $file = $testing ? 'test' . $testing . '.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE

my $sum = 0;

my %data;
for ( my $idx = 0; $idx <= $#input; $idx++ ) {
    say $idx if $idx % 100 == 0;
    my $n     = $input[$idx];
    my $count = 0;
    my @list;
    push @list, $n % 10;
    while ( $count < 2000 ) {

        $n = generate_num($n);
        push @list, $n % 10;

        $count++;
    }
    my @diffs;
    for ( my $i = 0; $i < $#list; $i++ ) {
        push @diffs, [ $list[ $i + 1 ] - $list[$i], $list[ $i + 1 ] ];
    }
    $sum += $n;
    say scalar @diffs if ( $testing == 4 or $testing == 5 );
    if ($testing) {
        my @last = @diffs[ 0 .. 8 ];
        dump \@last;
    }
    for ( my $i = 0; $i <= $#diffs - 3; $i++ ) {
        push @{ $data{ join( $;, map { $diffs[ $i + $_ ]->[0] } ( 0 .. 3 ) ) }
                ->{$idx} }, $diffs[ $i + 3 ]->[1];
    }
}

say "==> counting bananas";
my %bananas;
for my $key ( keys %data ) {
    my $b_sum = 0;
    for my $list_id ( keys %{ $data{$key} } ) {
        $b_sum += $data{$key}->{$list_id}->[0];
    }
    $bananas{$key} = $b_sum;
}
my $part2 = max values %bananas;
say $part2;
### FINALIZE - tests and run time
if ( !$testing ) {
    is( $sum,   18261820068, "Part 1: $sum" );
    is( $part2, 2044,        "Part 2: $part2" );
} elsif ( $testing == 1 ) {
    is( $sum, 37327623, "TEST 1: $sum" );

# tests 4 and 5 credit https://old.reddit.com/r/adventofcode/comments/1hjz1w4/2024_day_22_part_2_a_couple_of_diagnostic_test/
} elsif ( $testing == 4 ) {
    is( $sum,   18183557, "TEST 4: $sum" );
    is( $part2, 27,       "TEST 4: $part2" );

} elsif ( $testing == 5 ) {
    is( $sum,   8876699, "TEST 5: $sum" );
    is( $part2, 27,      "TEST 5: $part2" );
}

done_testing();
say sec_to_hms( tv_interval($start_time) );
### SUBS

sub generate_num {
    my ($n) = @_;
    my $p1 = $n * 64;
    $p1 = $n ^ $p1;
    $p1 = $p1 % 16777216;
    my $p2 = int( $p1 / 32 );
    $p2 = $p1 ^ $p2;
    $p2 = $p2 % 16777216;
    my $p3 = $p2 * 2048;
    $p3 = $p2 ^ $p3;
    return $p3 % 16777216;
}

sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 22: Monkey Market

=encoding utf8

A bunch of off-by-one errors plagued me today, along with the first
time this year that my $5 VPS wasn't really up to scratch. I guess the
enormous amount of allocations just swamped it, although I never got
an error.

A helpful post on the subreddit provided me with some useful test
cases that really helped. Credit in source!

On a ten year old NUC it runs in around 15s.

Rating: 4/5

Score: 2

Leaderboard completion time: 12m15s

=cut
