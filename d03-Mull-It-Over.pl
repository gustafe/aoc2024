#! /usr/bin/env perl
# Advent of Code 2024 Day 3 - Mull It Over - part 1 / part 2 / complete solution
# https://adventofcode.com/2024/day/3
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
my $file = $testing ? 'test2.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my @items;
while (@input) {
    my $line = shift @input;
    my @list = $line =~ m/(mul\(\d+\,\d+\)|do\(\)|don\'t\(\))/g;
    push @items, @list;
}

my %sums;
my $enabled = 0;

if ( $items[0] =~ /mul/ or $items[0] eq 'do()' ) {
    $enabled = 1;
}

for my $item (@items) {
    my ( $f1, $f2 ) = $item =~ /mul\((\d+)\,(\d+)\)/;
    $sums{1} += $f1 * $f2 if ( $f1 and $f2 );
    $sums{2} += $f1 * $f2 if ( $f1 and $f2 and $enabled );
    $enabled = 1 if $item eq 'do()';
    $enabled = 0 if $item eq "don't()";
}

### FINALIZE - tests and run time
is( $sums{1}, 185797128, "Part 1: $sums{1}" );
is( $sums{2}, 89798695,  "Part 2: $sums{2}" );
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

=head3 Day 3: Mull It Over

=encoding utf8

I'm going to add a new section to my "HOWTO AoC" post - a little regex
goes a long way.


Score: 2

Leaderboard completion time: 03m22s

=cut
