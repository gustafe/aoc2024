#! /usr/bin/env perl
# Advent of Code 2024 Day 18 - RAM Run - part 1 / part 2 / complete solution
# https://adventofcode.com/2024/day/18
# https://gerikson.com/files/AoC2024/UNLICENSE
###########################################################
use Modern::Perl '2015';
# useful modules
use List::Util qw/sum/;
use Data::Dump qw/dump/;
use Test::More;
use Array::Heap::PriorityQueue::Numeric;
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
sub dump_map;
my $byte   = 0;
my %limits = (
    xmax   => $testing ? 6  : 70,
    ymax   => $testing ? 6  : 70,
    amount => $testing ? 12 : 1024
);

# preload the map up until the answer required for part 1

while ( $byte < $limits{amount} - 1 ) {
    my $line = $input[$byte];
    my ( $x, $y ) = $line =~ m/^(\d+)\,(\d+)$/;
    $Map->{$x}{$y} = '#';
    $byte++;
}
my ( $part1, $part2 ) = ( undef, undef );
BYTE: for my $idx ( $byte .. $#input ) {
    my ( $x, $y ) = $input[$idx] =~ m/^(\d+)\,(\d+)$/;
    $Map->{$x}{$y} = '#';

    # find a path
    my $pq = Array::Heap::PriorityQueue::Numeric->new();
    $pq->add( [ 0, 0, 0 ], 0 );
    my $came_from;
    my $cost_so_far->{0}{0} = 0;
    my $path_found = 0;

    #    printf("byte at %d [%s]: ", $idx, $input[$idx]);
SEARCH: while ( $pq->peek() ) {
        no warnings 'uninitialized';
        my $curr = $pq->get();
        my $step = $curr->[2];
        if ( $curr->[0] == $limits{xmax} and $curr->[1] == $limits{ymax} ) {
            printf( "byte %d [%s] - goal reached in %d steps\n",
                $idx, $input[$idx], $step )
                if $idx % 2**4 == 0;
            $path_found = 1;
            $part1      = $step unless $part1;
            last SEARCH;

        }

        # try to move
        $step += 1;
        for my $d ( [ 0, -1 ], [ 0, 1 ], [ -1, 0 ], [ 1, 0 ] ) {
            my ( $dx, $dy ) = ( $curr->[0] + $d->[0], $curr->[1] + $d->[1] );
            next if ( $dx < 0 or $dx > $limits{xmax} );
            next if ( $dy < 0 or $dy > $limits{ymax} );
            next if $Map->{$dx}{$dy} eq '#';
            my $new_cost = $cost_so_far->{ $curr->[0] }{ $curr->[1] } + 1;
            if (  !$cost_so_far->{$dx}{$dy}
                or $new_cost < $cost_so_far->{$dx}{$dy} )
            {
                $cost_so_far->{$dx}{$dy} = $new_cost;
                $pq->add( [ $dx, $dy, $step ], $new_cost );
            }

            $came_from->{$dx}{$dy} = $curr;
        }
    }
    if ( !$path_found ) {
        $part2 = $input[$idx];
        last BYTE;
    }

}

### FINALIZE - tests and run time
is( $part1, 348,     "Part 1: $part1" );
is( $part2, '54,44', "Part 2: $part2" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub dump_map {
    print '  ' . join( '', map { $_ % 10 } ( 0 .. $limits{ymax} ) ) . "\n";
    for my $y ( 0 .. $limits{ymax} ) {
        printf "%2d", $y;
        for my $x ( 0 .. $limits{xmax} ) {
            print $Map->{$x}{$y} ? $Map->{$x}{$y} : '.';    #
        }
        print "\n";
    }
}
sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}


###########################################################

=pod

=head3 Day 18: RAM Run

=encoding utf8

This is what's called a "breather episode". Basic Dijkstra's combined with adding blocks until no paths are found. Runs in around a minute. Can probably be optimized. 

Score: 2

Leaderboard completion time: 05m55s

=cut
