#! /usr/bin/env perl
# Advent of Code 2024 Day 01 - Historian Hysteria - complete solution
# https://adventofcode.com/2024/day/01
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
my @left;
my @right;
my %lfreq;
my %rfreq;
for my $pair (@input) {
    my ( $l, $r ) = $pair =~ m/^(\d+)\s+(\d+)$/;
    push @left,  $l;
    push @right, $r;
    $lfreq{$l}++;
    $rfreq{$r}++;
}
say " Left list has " . scalar @left . " elements";
say "Right list has " . scalar @right . " elements";
say " Left freq has " . scalar( keys %lfreq ) . " elements";
say "Right freq has " . scalar( keys %rfreq ) . " elements";

warn "!!> assumptions incorrect - items in left column not unique"
    unless scalar @left == scalar( keys %lfreq );
@left  = sort { $a <=> $b } @left;
@right = sort { $a <=> $b } @right;

my @diffs;
while (@left) {
    my $l = shift @left;
    my $r = shift @right;
    push @diffs, abs( $l - $r );
}
my $ans1 = sum @diffs;

my @similars;
for my $num ( keys %lfreq ) {
    if ( $rfreq{$num} ) {
        push @similars, $num * $rfreq{$num};
    }
}
my $ans2 = sum @similars;

### FINALIZE - tests and run time
is( $ans1, 1506483,  "Part1: $ans1" );
is( $ans2, 23126924, "Part2: $ans2" );
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

=head3 Day 01: Historian Hysteria

=encoding utf8

Not a difficult problem, as expected from day 1. For some reason I
just guessed that the items in the left list would be unique, but wise
from previous problems I actually checked this.

Score: 2

Leaderboard completion time: 02m31s

=cut

