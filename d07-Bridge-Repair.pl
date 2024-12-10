#! /usr/bin/env perl
# Advent of Code 2024 Day 7 - Bridge Repair - complete solution: pass an arg for part 2
# https://adventofcode.com/2024/day/7
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
my $part2 = shift @ARGV // 0;
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my @calibs;
for my $line (@input) {
    my ( $target, $rest ) = split( /: /, $line );
    my @list = split( /\s+/, $rest );
    push @calibs, { target => $target, list => \@list };
}

# BFS
my %results;
if ($part2) { say "getting the answer to part 2, please be patient... " }
for my $el (@calibs) {
    my @map   = @{ $el->{list} };
    my @queue = ( { idx => 0, res => $map[0] } );
BFS: while (@queue) {

        my $cur      = shift @queue;
        my $next_idx = $cur->{idx} + 1;
        if ( defined $map[$next_idx] ) {
            my $add    = $cur->{res} + $map[$next_idx];
            my $mul    = $cur->{res} * $map[$next_idx];
            my $concat = $cur->{res} . $map[$next_idx] if $part2;

            if ( $add == $el->{target} and $next_idx == $#map ) {
                $results{ $el->{target} }++;
                last BFS;
            }
            if ( $mul == $el->{target} and $next_idx == $#map ) {
                $results{ $el->{target} }++;
                last BFS;
            }
            if ( $part2 and $concat == $el->{target} and $next_idx == $#map )
            {
                $results{ $el->{target} }++;
                last BFS;
            }

            push @queue, { idx => $next_idx, res => $add }
                unless ( $add > $el->{target} );
            push @queue, { idx => $next_idx, res => $mul }
                unless ( $mul > $el->{target} );
            if ($part2) {
                push @queue, { idx => $next_idx, res => $concat }
                    unless ( $concat > $el->{target} );
            }

        } else {
            last BFS;
        }
    }
}

my $answer = sum( keys %results );
### FINALIZE - tests and run time
if ($part2) {
    is( $answer, 105517128211543, "Part 2: $answer" ) unless $testing;
} else {
    is( $answer, 3245122495150, "Part 1: $answer" ) unless $testing;
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

=head3 Day 7: Bridge Repair

=encoding utf8

This was a fun one! I naively tried a combinatorics solution before
settling on a depth-first search instead. This is plenty fast for part
1 and still takes around 30s on part 2. 

Of course everyone and their preferred parental unit used recursion,
but that's too advanced for this smooth brain.

Rating: 4/5

Score: 2

Leaderboard completion time: 03m47s

=cut

