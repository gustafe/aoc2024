#! /usr/bin/env perl
# Advent of Code 2024 Day 14 - Restroom Redoubt - complete solution
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
my $robots;
my $Map;
sub dump_map;
my $id = 1;
for my $line (@input) {
    my ( $px, $py, $vx, $vy )
        = $line =~ /^p\=(\d+),(\d+) v\=(-?\d+),(-?\d+)$/;
    push @{ $Map->{$px}{$py} }, $id;
    $robots->{$id} = { dx => $vx, dy => $vy };
    $id++;
}
if ($testing) {

    dump $robots;
}

my $xmax = $testing ? 11 : 101;
my $ymax = $testing ? 7  : 103;

my $data;
my %peek = ( 11 => 1, 2 => 1, 6 => 1, 9 => 1 );
for my $seconds ( 0 .. 8000 ) {
    say "-> $seconds... " if $seconds % 100 == 0;
    my $newmap;
    say "==> $seconds" if ( $testing and $seconds < 6 );
    for my $x ( 0 .. $xmax - 1 ) {
        for my $y ( 0 .. $ymax - 1 ) {
            next unless $Map->{$x}{$y};
            while ( @{ $Map->{$x}{$y} } ) {

                my $curr = shift @{ $Map->{$x}{$y} };
                printf( "R: %d at [%d,%d]\n", $curr, $x, $y )
                    if ( $testing and $peek{$curr} and $seconds < 6 );
                my ( $xn, $yn )
                    = ( $x + $robots->{$curr}{dx},
                    $y + $robots->{$curr}{dy} );

                if ( $xn < 0 or $xn >= $xmax ) {
                    $xn = $xn % $xmax;
                }
                if ( $yn < 0 or $yn >= $ymax ) {
                    $yn = $yn % $ymax;
                }
                printf( "R: %d move to [%d,%d]\n", $curr, $xn, $yn )
                    if ( $testing and $peek{$curr} and $seconds < 6 );
                push @{ $newmap->{$xn}{$yn} }, $curr;
            }
        }
    }
    $Map = clone $newmap;
    if ( $testing and $seconds > 97 ) {
        say "==> $seconds";
        dump_map;
    }
    $data->{$seconds} = calculate_safety();
}
say $data->{99};

# the assumption here is that the result with the lowest total safety
# score will be the iteration of the map with the desired
# image. Visual inspection of the map confirms this.

my $min_safety = 50 * 51 * 50 * 51 * 50 * 51 * 50 * 51;
my $min_k      = -1;
for my $k ( keys %$data ) {
    if ( $data->{$k} < $min_safety ) {
        $min_safety = $data->{$k};
        $min_k      = $k;
    }
}

my $ans2 = $min_k + 1;
### FINALIZE - tests and run time
is( $data->{99}, 221616000, "Part 1: $data->{99}" );
is( $ans2,       7572,      "Part 2: " . $ans2 );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub calculate_safety {
    my $quad;
    my $mid_x = ( $xmax - 1 ) / 2;
    my $mid_y = ( $ymax - 1 ) / 2;

    #   say "$mid_x | $mid_y";
    for my $y ( 0 .. $ymax - 1 ) {
        for my $x ( 0 .. $xmax - 1 ) {
            next if $x == $mid_x;
            next if $y == $mid_y;
            next unless $Map->{$x}{$y};
            if ( $x < $mid_x and $y < $mid_y ) {
                $quad->{1} += scalar @{ $Map->{$x}{$y} };
            }
            if ( $x > $mid_x and $y < $mid_y ) {
                $quad->{2} += scalar @{ $Map->{$x}{$y} };
            }
            if ( $x < $mid_x and $y > $mid_y ) {
                $quad->{3} += scalar @{ $Map->{$x}{$y} };
            }
            if ( $x > $mid_x and $y > $mid_y ) {
                $quad->{4} += scalar @{ $Map->{$x}{$y} };
            }
        }
    }
    my $prod = 1;
    for my $q ( keys %$quad ) {
        $prod *= $quad->{$q};
    }
    return $prod;
}

sub dump_map {
    print '   ' . join( '', map { $_ % $xmax } ( 0 .. $xmax - 1 ) ) . "\n"
        if $testing;
    for my $r ( 0 .. $ymax - 1 ) {
        printf "%2d ", $r if $testing;
        for my $c ( 0 .. $xmax - 1 ) {
            if ( $Map->{$c}{$r} ) {
                print scalar @{ $Map->{$c}{$r} };
            } else {
                print '.';
            }
        }
    }

    print "\n";

    print '   ' . join( '', map { $_ % $xmax } ( 0 .. $xmax - 1 ) ) . "\n"
        if $testing;
}

sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

# https://adventofcode.com/2024/day/14
# https://gerikson.com/files/AoC2024/UNLICENSE
###########################################################

###########################################################

=pod

=head3 Day 14: Restroom Redoubt

=encoding utf8

A fun problem once you got around the incredibly vague requirement for part 2. 

Rating: 4/5

Score: 2

Leaderboard completion time: 15m48s

=cut

