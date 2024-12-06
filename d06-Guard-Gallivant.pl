#! /usr/bin/env perl
# Advent of Code 2024 Day 6 - Guard Gallivant - complete solution
# https://adventofcode.com/2024/day/6
# https://gerikson.com/files/AoC2024/UNLICENSE
###########################################################

use Modern::Perl '2015';
# useful modules
use List::Util qw/sum/;
use Data::Dump qw/dump/;
use Test::More;

use Time::HiRes qw/gettimeofday tv_interval/;
use Clone qw/clone/;
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
my $pos;
my %dirs  = ( N => [ -1, 0 ], E => [ 0, 1 ], W => [ 0, -1 ], S => [ 1, 0 ] );
my %turns = ( N => 'E',       E => 'S',      S => 'W',       W => 'N' );
my $visited;
my $visited_turns;
my $curr_dir;
my $r = 1;

for my $line (@input) {
    my $c = 1;
    for my $chr ( split( //, $line ) ) {
        $Map->{$r}{$c} = $chr;
        if ( $chr eq '^' ) {
            $pos      = [ $r, $c ];
            $curr_dir = 'N';

            #	    $visited->{$r}{$c}++;
            $Map->{$r}{$c} = '.';    # mark spot free
        }
        $c++;
    }
    $r++;
}
my $start_pos = [ $pos->[0], $pos->[1] ];

# part 1
my $res = traverse_map( [] );
my $original_path;
my $count;
if ($res) {
    $original_path = clone $res;
    for my $r ( keys %$res ) {
        for my $c ( keys %{ $res->{$r} } ) {
            $count++;
        }
    }
}


# part 2

my $candidates;
for my $r (  keys %$original_path ) {

    #    say "==> $r" if $r%10==0;
    for my $c (  keys %{ $original_path->{$r} } ) {
        next if $Map->{$r}{$c} eq '#';
        next if ( $r == $start_pos->[0] and $c == $start_pos->[1] );

        my $res = traverse_map( [ $r, $c ] );
        if ($res) {
	    # nop
        } else {
            say "possible loop at [$r,$c]";
            $candidates++;
        }
    }
}
say "candidates: $candidates";

### FINALIZE - tests and run time

is( $count, 4758, "Part 1: $count" );

is( $candidates, 1670, "Part 2: $candidates" );

done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub traverse_map {
    no warnings 'uninitialized';
    my ($addition) = @_;
    dump $addition if $testing;
    my $local_map = clone $Map;
    if ($addition) {
        $local_map->{ $addition->[0] }{ $addition->[1] } = '#';
    }
    my $visited;
    my $visited_turns;
#    my $loop_count = 0;
    my $pos        = clone $start_pos;
    my $curr_dir   = 'N';
    my $left_map   = 0;
LOOP: while ( 1 ) {

        # try to move
        my $next = [
            $pos->[0] + $dirs{$curr_dir}->[0],
            $pos->[1] + $dirs{$curr_dir}->[1]
        ];
        if ( $local_map->{ $next->[0] }{ $next->[1] } eq '.' ) {
            $visited->{ $pos->[0] }{ $pos->[1] }++;
            $pos = clone $next;

        } elsif ( $local_map->{ $next->[0] }{ $next->[1] } eq '#' ) {
            $visited->{ $pos->[0] }{ $pos->[1] }++;

            if ( $visited_turns->{ $pos->[0] }{ $pos->[1] } ) {
                if ( $visited_turns->{ $pos->[0] }{ $pos->[1] } > 1 ) {

                    # let's say we have a loop
                    last LOOP;
                }
                $visited_turns->{ $pos->[0] }{ $pos->[1] }++;
            } else {
                $visited_turns->{ $pos->[0] }{ $pos->[1] }++;
            }
            $curr_dir = $turns{$curr_dir};
            # position remains unchanged

        } elsif ( !$local_map->{ $next->[0] }{ $next->[1] } ) {  # edge of map
            $visited->{ $pos->[0] }{ $pos->[1] }++;

            $left_map = 1;
            last LOOP;
        }
 #       $loop_count++;
    }
    my $res;
    if ($left_map) {
        $res = clone $visited;
    } else {
	# nop
    }

    return $res;
}


sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 6: Guard Gallivant

=encoding utf8

A tough but enjoyable puzzle. Part 2 threw me for a bit of a loop but
I opted for a brute-force solution. With some optimization it runs at
around 5m on my machine.

Rating: 4/5

Score: 2

Leaderboard completion time: 08m53s

=cut
