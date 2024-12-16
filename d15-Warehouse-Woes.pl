#! /usr/bin/env perl
# Advent of Code 2024 Day 15 - Warehouse Woes - part 1
# https://adventofcode.com/2024/day/15
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
my $Map;
my $r = 0;
my $robpos;
my $ops;
my $is_map = 1;
sub dump_map;
sub map_val { my ($p) = @_; return $Map->{ $p->[0] }{ $p->[1] }; }
for my $line (@input) {
    if ( length($line) == 0 ) {
        $is_map = 0;
        next;
    }
    if ($is_map) {
        my $c = 0;
        for my $chr ( split( //, $line ) ) {
            if ( $chr eq '@' ) {
                $robpos = [ $r, $c ];
                $Map->{$r}{$c} = '.';
            } else {
                $Map->{$r}{$c} = $chr;
            }
            $c++;
        }
        $r++;
    } else {
        push @$ops, split( //, $line );
    }
}

say scalar @$ops if $testing;

my %dirs = (
    '^' => [ -1, 0 ],
    'v' => [ 1,  0 ],
    '<' => [ 0,  -1 ],
    '>' => [ 0,  1 ]
);
OP: while (@$ops) {
    my $op = shift @$ops;
    printf( "==> robot starting at [%2d,%2d] move: %s\n", @$robpos, $op )
        if $testing;

    my $move
        = [ $robpos->[0] + $dirs{$op}->[0], $robpos->[1] + $dirs{$op}->[1] ];
    my $next_cell = map_val($move);
    if ( $next_cell ne 'O' ) {
        $robpos = $move if $next_cell eq '.';
        next OP;
    }
    my $end = $move;
    while ( map_val($end) eq 'O' ) {
        $end = [ $end->[0] + $dirs{$op}->[0], $end->[1] + $dirs{$op}->[1] ];
    }
    next OP if ( map_val($end) eq '#' );

    # switch position of front box
    $Map->{ $end->[0] }{ $end->[1] }   = 'O';
    $Map->{ $move->[0] }{ $move->[1] } = '.';
    $robpos                            = $move;

}
my $gps;
for my $r ( 0 .. max keys %$Map ) {
    for my $c ( 0 .. max keys %{ $Map->{1} } ) {
        if ( $Map->{$r}{$c} eq 'O' ) {
            $gps += 100 * $r + $c;
        }
    }
}

### FINALIZE - tests and run time
is( $gps, 1442192, "Part 1: $gps" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub dump_map {
    print '   '
        . join( '', map { $_ % 10 } ( 0 .. ( max keys %{ $Map->{1} } ) ) )
        . "\n";
    for my $r ( 0 .. ( max keys %$Map ) ) {
        printf "%2d ", $r;
        for my $c ( 0 .. ( max keys %{ $Map->{1} } ) ) {
            if ( $robpos->[0] == $r and $robpos->[1] == $c ) {
                print '@';
            } else {
                print $Map->{$r}{$c};
            }

        }
        print "\n";
    }
    printf "Robot at [%2d,%2d]\n", @$robpos;
}


sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 15: Warehouse Woes

=encoding utf8  

Part 1 done, part 2 in the backlog

Score: 1

Leaderboard completion time: 30m00s

=cut
