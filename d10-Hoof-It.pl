#! /usr/bin/env perl
# Advent of Code 2024 Day 10 - Hoof It - complete solution
# https://adventofcode.com/2024/day/10
# https://gerikson.com/files/AoC2024/UNLICENSE
###########################################################

use Modern::Perl '2015';

# useful modules
use List::Util qw/sum/;
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
my $Map;
my $starts;
my $r = 1;

for my $line (@input) {
    my $c = 1;
    for my $h ( split( //, $line ) ) {
        $Map->{$r}{$c} = $h;
        if ( ord($h) == 48 ) {
            $starts->{$r}{$c}++;
        }
        $c++;
    }
    $r++;
}
my $paths;
my %dirs = ( N => [ -1, 0 ], S => [ 1, 0 ], E => [ 0, 1 ], W => [ 0, -1 ] );
for my $r_start ( sort { $a <=> $b } keys %$starts ) {
    for my $c_start ( sort { $a <=> $b } keys %{ $starts->{$r_start} } ) {
        say "starting search at ($r_start,$c_start)" if $testing;
        push my @stack, [ $r_start, $c_start ];
    DFS: while (@stack) {
            no warnings 'uninitialized';
            my $curr = pop @stack;
            my $val  = $Map->{ $curr->[0] }{ $curr->[1] };

            # try to move
            for my $d ( keys %dirs ) {
                my $next = [
                    $curr->[0] + $dirs{$d}->[0],
                    $curr->[1] + $dirs{$d}->[1]
                ];
                if ( $Map->{ $next->[0] }{ $next->[1] } - $val == 1 ) {
                    if ( $Map->{ $next->[0] }{ $next->[1] } == 9 ) {

                        # found the end of a path, add it to the list of paths
                        say "found target at ($next->[0],$next->[1])" if $testing;
                        $paths->{$r_start}{$c_start}{ $next->[0] }{ $next->[1] }++;
                    }
                    push @stack, $next;
                }
            }
        }
    }
}
my $ans;
for my $sr ( keys %$paths ) {
    for my $sc ( keys %{ $paths->{$sr} } ) {
        for my $tr ( keys %{ $paths->{$sr}{$sc} } ) {
            for my $tc ( keys %{ $paths->{$sr}{$sc}{$tr} } ) {
                $ans->{1}++;
                $ans->{2} += $paths->{$sr}{$sc}{$tr}{$tc};
            }
        }
    }
}

### FINALIZE - tests and run time
is( $ans->{1}, 717,  "Part 1: $ans->{1}" );
is( $ans->{2}, 1686, "Part 2: $ans->{2}" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub sec_to_hms {
    my ($s) = @_;
    return sprintf(
        "Duration: %02dh%02dm%02ds (%.3f ms)",
        int( $s / (3600) ),
        ( $s / 60 ) % 60,
        $s % 60, $s * 1000
    );
}

###########################################################

=pod

=head3 Day 10: Hoof It

=encoding utf8

This year's easiest part 2 for me, I just happened to record the data
needed. Judging from the subreddit, so did everyone else.

Rating: 3/5

Score: 2

Leaderboard completion time: 04m14s

=cut
