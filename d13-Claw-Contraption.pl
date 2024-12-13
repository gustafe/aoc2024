#! /usr/bin/env perl
# Advent of Code 2024 Day 13 - Claw Contraption - complete solution
# https://adventofcode.com/2024/day/13
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
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my @list;
my %costs = ( A => 3, B => 1 );
while (@input) {
    my @A      = shift(@input) =~ /X\+(\d+), Y\+(\d+)/;
    my @B      = shift(@input) =~ /X\+(\d+), Y\+(\d+)/;
    my @target = shift(@input) =~ /X\=(\d+), Y\=(\d+)/;
    shift @input;
    push @list, { A => \@A, B => \@B, target => \@target };
}
my $ans;

# part 1
say "Solving part 1, please be patient...";
my $machines=1;
for my $el (@list) {
    say "$machines machines checked" if $machines % 10==0;
    # use a priority queue to search for the target
    my $pq = Array::Heap::PriorityQueue::Numeric->new();
    $pq->add( { x => 0, y => 0, A => 0, B => 0 }, 0 );
    my $came_from;
    my $cost_so_far;
    $cost_so_far->{0}{0} = 0;

SEARCH:
    while ( $pq->peek() ) {
        my $curr = $pq->get();
        if (    $curr->{x} == $el->{target}[0]
            and $curr->{y} == $el->{target}[1] )
        {
#            dump $curr;
            say "target reached at total cost of "
                . sum( map { $curr->{$_} * $costs{$_} } qw/A B/ )
                if $testing;
            $ans->{1} += sum( map { $curr->{$_} * $costs{$_} } qw/A B/ );
            last SEARCH;
        }

        # try to move
        for my $btn (qw/A B/) {
            my $dx      = $curr->{x} + $el->{$btn}[0];
            my $dy      = $curr->{y} + $el->{$btn}[1];
            my $presses = { A => $curr->{A}, B => $curr->{B} };
            $presses->{$btn}++;
            next if $presses->{$btn} > 100;
            my $new_cost = $cost_so_far->{ $curr->{x} }{ $curr->{y} }
                + $curr->{$btn} * $costs{$btn};
            if ( !exists $cost_so_far->{$dx}{$dy}
                or $new_cost < $cost_so_far->{$dx}{$dy} )
            {
                $cost_so_far->{$dx}{$dy} = $new_cost;
                $pq->add(
                    {   x => $dx,
                        y => $dy,
                        A => $presses->{A},
                        B => $presses->{B}}, $new_cost);
            }
        }
    }
    $machines++;
}

is( $ans->{1}, 31552, "Part 1: $ans->{1}" );
say sec_to_hms( tv_interval($start_time) );

# part 2 - linear algebra

for my $el (@list) {
    $el->{target}[0] += 10_000_000_000_000;
    $el->{target}[1] += 10_000_000_000_000;
    my $ret = min_tokens_to_win( $el->{A}, $el->{B}, $el->{target} );
    $ans->{2} += $ret->{A} * $costs{A} + $ret->{B} * $costs{B} if $ret;
}

### FINALIZE - tests and run time
is( $ans->{2}, 95273925552482, "Part 2: $ans->{2}" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS

sub min_tokens_to_win {
    my ( $A, $B, $target ) = @_;
    my ( $ax, $ay ) = @$A;
    my ( $bx, $by ) = @$B;
    my ( $X,  $Y )  = @$target;

    # solving the equations
    # ax * ta + bx * tb = X
    # ay * ta + by * tb = Y
    # allows us to factor out ta and tb

    my $tb = POSIX::floor( ( $ay * $X - $ax * $Y ) / ( $ay * $bx - $ax * $by ) );
    my $ta = POSIX::floor( ( $X - $bx * $tb ) / $ax );

    # only return if we have integer solutions
    if ( $ax * $ta + $bx * $tb == $X and $ay * $ta + $by * $tb == $Y ) {
        return { A => $ta, B => $tb };
    } else {
        return undef;
    }
}


sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 13: Claw Contraption

=encoding utf8

My first stab at linear algebra failed miserably, so I quickly cribbed
a search with priority queue from a previous year. This was way too
slow for part 2 so I revisited the algebra solution and figured out
how to only return integer solutions.

Score: 2

Leaderboard completion time: 11m04s

=cut
