#! /usr/bin/env perl
# Advent of Code 2024 Day 20 - Race Condition - part 1 / part 2 / complete solution
# https://adventofcode.com/2024/day/20
# https://gerikson.com/files/AoC2024/UNLICENSE
###########################################################
use Modern::Perl '2015';
# useful modules
use List::Util qw/sum all max/ ;
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
my $start;
my $end;

my $r = 1;
for my $line (@input) {
    my $c = 1;
    for my $chr ( split( //, $line ) ) {
        if ( $chr eq 'S' ) {
            $start = [ $r, $c ];
            $Map->{$r}{$c} = '.';
        } elsif ( $chr eq 'E' ) {
            $end = [ $r, $c ];
            $Map->{$r}{$c} = '.';
        } else {
            $Map->{$r}{$c} = $chr;
        }
        $c++;
    }
    $r++;
}

push my @queue, [ $end, 0 ];
my %distances;
SEARCH: while (@queue) {
    my ( $p, $step ) = @{ pop @queue };
    if ( exists $distances{ join( $;, @$p ) } ) {
        next SEARCH;
    }
    $distances{ join( $;, @$p ) } = [ $p, $step ];
    for my $v ( [ 0, 1 ], [ 0, -1 ], [ 1, 0 ], [ -1, 0 ] ) {
        my $move = [ $p->[0] + $v->[0], $p->[1] + $v->[1] ];
        push @queue, [ $move, $step + 1 ]
            if $Map->{ $move->[0] }{ $move->[1] } ne '#';
    }
}
my $ans;

# credit to /u/musifter as usual
# https://old.reddit.com/r/adventofcode/comments/1hicdtb/2024_day_20_solutions/m2ye0mf/
my @positions = keys %distances;
for ( my $i = 1; $i <= $#positions; $i++ ) {
    my $ipos  = $distances{ $positions[$i] }[0];
    my $istep = $distances{ $positions[$i] }[1];

    for ( my $j = 0; $j < $i; $j++ ) {
        my $mdist = abs( $ipos->[0] - $distances{ $positions[$j] }[0]->[0] )
            + abs( $ipos->[1] - $distances{ $positions[$j] }[0]->[1] );
        if ( $mdist >= 2 and $mdist <= 20 ) {
            my $saved_dist
                = abs( $istep - $distances{ $positions[$j] }[1] ) - $mdist;
            next unless $saved_dist >= 100;
            $ans->{1}++ if $mdist == 2;
            $ans->{2}++;
        }
    }
}

### FINALIZE - tests and run time
is( $ans->{1}, 1358,    "Part 1: $ans->{1}" );
is( $ans->{2}, 1005856, "Part 2: $ans->{2}" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS

sub dump_map {
    my ( $M, $s, $e ) = @_;

    say '   ' . join( '', map { $_ % 10 } ( 1 .. max( keys %{ $M->{1} } ) ) );

    for my $r ( 1 .. max( keys %$M ) ) {
        printf( "%2d ", $r );
        for my $c ( 1 .. max( keys %{ $M->{$r} } ) ) {
            my $chr;
            if ( $r == $s->[0] and $c == $s->[1] ) {
                $chr = 'S';
            } elsif ( $r == $e->[0] and $c == $e->[1] ) {
                $chr = 'E';
            } else {
                $chr = $M->{$r}{$c};
            }
            print $chr;
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

=head3 Day 20: Race Condition

=encoding utf8

I took a pass on this today too, but it was a fun problem.

Score: 0

Leaderboard completion time: 15m58s

=cut

