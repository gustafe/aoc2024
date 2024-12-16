#! /usr/bin/env perl
# Advent of Code 2024 Day 16 - Reindeer Maze - complete solution
# https://adventofcode.com/2024/day/16
# https://gerikson.com/files/AoC2024/UNLICENSE
###########################################################

use Modern::Perl '2015';
# useful modules
use List::Util qw/sum/;
use Data::Dump qw/dump/;
use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;
use Array::Heap::PriorityQueue::Numeric;
sub sec_to_hms;

my $start_time = [gettimeofday];
#### INIT - load input data from file into array

my $testing = 0;
my @input;
my $file = $testing ? 'test' . $testing . '.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my $Map;
my $r = 1;
my $start;
my $end;
for my $line (@input) {
    my $c = 1;
    for my $chr ( split( //, $line ) ) {
        if ( $chr eq 'S' ) { $start = { r => $r, c => $c, d => 'E' } }
        if ( $chr eq 'E' ) { $end   = { r => $r, c => $c, d => undef } }
        $Map->{$r}{$c} = $chr;
        $c++;
    }
    $r++;
}

my %dirs = (
    E => { rd => 0,  cd => 1,  L => 'N', R => 'S' },
    W => { rd => 0,  cd => -1, L => 'S', R => 'N' },
    S => { rd => 1,  cd => 0,  L => 'E', R => 'W' },
    N => { rd => -1, cd => 0,  L => 'W', R => 'E' },
);

# the construct to keep track of all paths is hat-tip /u/musifter:
# https://old.reddit.com/r/adventofcode/comments/1hfboft/2024_day_16_solutions/m2asui4/

my %paths;
my $min = ~0;
my $visited;
my $ans;
my $pq = Array::Heap::PriorityQueue::Numeric->new();

$pq->add( { r => $start->{r}, c => $start->{c}, d => 'E', cost => 0, path => {} } );


SEARCH: while ( $pq->peek() ) {
    my $curr = $pq->get();
    next SEARCH if ( $curr->{cost} > $min );
    if ( $curr->{r} == $end->{r} and $curr->{c} == $end->{c} ) {

        if ( $curr->{cost} < $min ) {
            say "Part 1: goal reached at total cost of " . $curr->{cost};
            $ans->{1} = $curr->{cost};
        }
        $min   = $curr->{cost};
        %paths = ( %paths, %{ $curr->{path} } );

        next SEARCH;
    }

    next SEARCH
      if ( ( $visited->{ $curr->{r} }{ $curr->{c} }{ $curr->{d} } // ~0 ) < $curr->{cost} );

    $visited->{ $curr->{r} }{ $curr->{c} }{ $curr->{d} } = $curr->{cost};

    # move in current direction, turn left and right
    my $rd = $curr->{r} + $dirs{ $curr->{d} }->{rd};
    my $cd = $curr->{c} + $dirs{ $curr->{d} }->{cd};

    if ( $Map->{$rd}{$cd} ne '#' ) {
        $pq->add(
            {   r    => $rd,
                c    => $cd,
                d    => $curr->{d},
                cost => $curr->{cost} + 1,
                path => { %{ $curr->{path} }, join( ',', $rd, $cd ) => 1 }
            },
            $curr->{cost} + 1
        );

    }

    for my $rot (qw/L R/) {
        my $newdir = $dirs{ $curr->{d} }{$rot};
        $pq->add(
            {   r    => $curr->{r},
                c    => $curr->{c},
                d    => $newdir,
                cost => $curr->{cost} + 1000,
                path => $curr->{path}
            },
            $curr->{cost} + 1000
        );
    }

}

$ans->{2} = 1 + scalar %paths;
### FINALIZE - tests and run time
if ($testing) {
    if ( $testing == 1 ) {
        is( $ans->{1}, 7036, "Test 1 Part 1: $ans->{1}" );
    } elsif ( $testing == 2 ) {
        is( $ans->{1}, 11048, "Test 2 Part 1: $ans->{1}" );
    }
} else {
    is( $ans->{1}, 66404, "Part 1: $ans->{1}" );
    is( $ans->{2}, 433,   "Part 2: $ans->{2}" );
}

done_testing();
say sec_to_hms(tv_interval($start_time));

### SUBS
sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 16: Reindeer Maze

=encoding utf8

Thank you C<Array::Heap::PriorityQueue::Numeric>!

Had to look for tips on how to keep track of all the paths in part 2. Credit in source. 

Score: 2

Leaderboard completion time: 13m47s

=cut
