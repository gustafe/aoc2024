#! /usr/bin/env perl
# Advent of Code 2024 Day 4 - Ceres Search - complete solution
# https://adventofcode.com/2024/day/4
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
my $r = 1;
for my $line (@input) {
    my $c = 1;
    for my $el ( split( //, $line ) ) {
        $Map->{$r}{$c} = $el;
        $c++;
    }
    $r++;
}
my %dirs = (
    E  => [ 0,  1 ],    W  => [ 0,  -1 ],    N  => [ -1, 0 ],    S  => [ 1,  0 ],
    SE => [ 1,  1 ],    NE => [ -1, 1 ],    NW => [ -1, -1 ],    SW => [ 1,  -1 ],
);

my %sums;
for my $r ( sort { $a <=> $b } keys %$Map ) {
    for my $c ( sort { $a <=> $b } keys %{ $Map->{$r} } ) {
        no warnings 'uninitialized';

        if ( $Map->{$r}{$c} eq 'X' ) {    # part 1
            for my $d ( keys %dirs ) {
                my @string = map { $Map->{$r+$dirs{$d}->[0]*$_}{ $c+$dirs{$d}->[1]*$_}} ( 1, 2, 3 );

                if ( join( '', @string ) eq 'MAS' ) {
		    say "string XMAS found at ($r,$c) with direction $d"  if $testing;
                    $sums{1}++;

                }
            }
        }
        if ( $Map->{$r}{$c} eq 'A' ) {
	    my ( $slash, $backslash ) =($Map->{$r+1}{$c-1} . $Map->{$r-1}{$c+1},
					$Map->{$r-1}{$c-1} . $Map->{$r+1}{$c+1});

	    if (($slash eq 'SM' or $slash eq 'MS') and ($backslash eq 'SM' or $backslash eq 'MS')) {
                say "X-MAS found centered on ($r,$c)" if $testing;
                $sums{2}++;
	    }
        }
    }
}

### FINALIZE - tests and run time
if (!$testing) {
is( $sums{1}, 2406, "Part 1: $sums{1}" );
is( $sums{2}, 1807, "Part 2: $sums{2}" );

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

=head3 Day 4: Ceres Search

=encoding utf8

Not a difficult problem, but a fiddly one. 

As usual I represent the "map" as a hashref of hashrefs, because I want to be able to use negative indices without the risk of "wrapping around" which is a risk if you use arrays or arrayrefs. 

Score: 2

Leaderboard completion time: 05m41s

=cut
