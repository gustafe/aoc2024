#! /usr/bin/env perl
# Advent of Code 2024 Day 8 - Resonant Collinearity - complete solution
# https://adventofcode.com/2024/day/8
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
my $antennas;
my $antinodes;
my $r = 1;
for my $line (@input) {
    my $c = 1;
    for my $chr ( split( //, $line ) ) {
	# avoid having a literal 0 as a key, messes up existence test
	# later
        if ( ord($chr) == 48 ) {
	    # my input does not have a 'O' in it, if yours does, this
	    # might be an issue
            $chr = 'O'; 
        }

        $Map->{$r}{$c} = $chr;
        if ( $chr ne '.' ) {
            push @{ $antennas->{$chr} }, [ $r, $c ];
        }
        $c++;
    }
    $r++;
}
dump $antennas if $testing;
if ($testing) {
    for my $r ( sort { $a <=> $b } keys %$Map ) {
        for my $c ( sort { $a <=> $b } keys %{ $Map->{$r} } ) {
            print $Map->{$r}{$c};
        }
        print "\n";
    }
}

for my $type ( keys %$antennas ) {
    my @coord = @{ $antennas->{$type} };

    for ( my $i = 0; $i <= $#coord; $i++ ) {
        for ( my $j = 0; $j <= $#coord; $j++ ) {
            next if $i == $j;

            my @delta = (
                $coord[$j]->[0] - $coord[$i]->[0],
                $coord[$j]->[1] - $coord[$i]->[1]
            );
            my $start_i = [ $coord[$i]->[0], $coord[$i]->[1] ];
            my $start_j = [ $coord[$j]->[0], $coord[$j]->[1] ];
            my ( $step_i, $step_j ) = ( 0, 0 );
            while ( $Map->{ $start_i->[0] }{ $start_i->[1] } ) {
                $antinodes->{p2}{ $start_i->[0] }{ $start_i->[1] }++;

		# the rules are a bit vague here but for part one only
		# one specific antinode is what we want. This
		# convoluted logic is to capture that
                $antinodes->{p1}{ $start_i->[0] }{ $start_i->[1] }++
                    if $step_i == 1;

                $start_i = [ $start_i->[0] - $delta[0],
                             $start_i->[1] - $delta[1] ];
                $step_i++;
            }
            while ( $Map->{ $start_j->[0] }{ $start_j->[1] } ) {
                $antinodes->{p2}{ $start_j->[0] }{ $start_j->[1] }++;
                $antinodes->{p1}{ $start_j->[0] }{ $start_j->[1] }++
                    if $step_j == 1;
                $start_j = [ $start_j->[0] + $delta[0],
                             $start_j->[1] + $delta[1] ];
                $step_j++;
            }
        }
    }
}
my $node_count = { p1 => 0, p2 => 0 };

for my $r ( sort { $a <=> $b } keys %$Map ) {
    for my $c ( sort { $a <=> $b } keys %{ $Map->{$r} } ) {
        for my $k (qw/p1 p2/) {
            $node_count->{$k}++ if $antinodes->{$k}{$r}{$c};
        }
    }
    print "\n" if $testing;
}

### FINALIZE - tests and run time
is( $node_count->{p1}, 254, "Part 1: $node_count->{p1}" );
is( $node_count->{p2}, 951, "Part 2: $node_count->{p2}" );

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

=head3 Day 8: Resonant Collinearity

=encoding utf8

This wasn't a very hard problem really, but the description was
unusually vague for AoC. In the end I just had to work against the
example and change my code until I got the same result.

Also shoutout to Eric, that I<scamp>, that included a zero in the data
set that totally broke my existence code in part 2. It was a fun thing
to figure out.

Score: 2

Leaderboard completion time: 07m12s

=cut

