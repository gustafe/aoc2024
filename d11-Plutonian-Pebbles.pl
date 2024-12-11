#! /usr/bin/env perl
# Advent of Code 2024 Day 11 - Plutonian Pebbles - complete solution
# https://adventofcode.com/2024/day/11
# https://gerikson.com/files/AoC2024/UNLICENSE
###########################################################

use Modern::Perl '2015';
# useful modules
use List::Util qw/sum all/;
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
my $ans;
my @stones  = split( /\s+/, $input[0] );
my %current = map { $_ => 1 } ( split( /\s+/, $input[0] ) );

### Part 1

# straightforward counting solution

my $blinks = 0;
while ( $blinks < 25 ) {
    my @new;
    for my $stone (@stones) {
        if ( ord($stone) == 48 ) { push @new, 1 }
        elsif ( length($stone) % 2 == 0 ) {

            # I'll do anything to avoid having to deal with substr
            my @pieces = split( //, $stone );
            my @bot    = @pieces[ 0 .. ( scalar @pieces ) / 2 - 1 ];
            my @top    = @pieces[ ( scalar @pieces ) / 2 .. $#pieces ];
            while ( $bot[0] == 0 and scalar @bot > 1 ) {
                shift @bot;
            }
            while ( $top[0] == 0 and scalar @top > 1 ) {
                shift @top;
            }
            push @new, join( '', @bot );
            push @new, join( '', @top );
        } else {
            push @new, $stone * 2024;
        }
    }
    say join( ' ', @new ) if $testing and $blinks <= 6;
    say "=> $blinks " . scalar @new if $testing;
    @stones = @new;
    $blinks++;
}
$ans->{1} = scalar @stones;

### Part 2
for my $blinks ( 1 .. 75 ) {
    my %new;

# credit for the idea of using a "bag" for keeping track of the values goes to /u/musifter:
# https://www.reddit.com/r/adventofcode/comments/1hbm0al/2024_day_11_solutions/m1hhzq0/

    for my $key ( keys %current ) {
        if ( $key == 0 ) { $new{1} += $current{$key} }
        elsif ( length($key) % 2 == 0 ) {
            my @pieces = split( //, $key );
            my @bot    = @pieces[ 0 .. ( scalar @pieces ) / 2 - 1 ];
            my @top    = @pieces[ ( scalar @pieces ) / 2 .. $#pieces ];
            while ( $bot[0] == 0 and scalar @bot > 1 ) {
                shift @bot;
            }
            while ( $top[0] == 0 and scalar @top > 1 ) {
                shift @top;
            }
            $new{ join( '', @bot ) } += $current{$key};
            $new{ join( '', @top ) } += $current{$key};
        } else {
            $new{ $key * 2024 } += $current{$key};
        }

    }
    %current = %new;

}

$ans->{2} = sum( values %current );

### FINALIZE - tests and run time
is( $ans->{1}, 193269,          "Part 1: $ans->{1}" );
is( $ans->{2}, 228449040027793, "Part 2: $ans->{2}" );

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

=head3 Day 11: Plutonian Pebbles

=encoding utf8

I awarded myself a "freebie" for part 2 today because the solution I
found in the subreddit (see comments for credit) was so elegant, and I
felt I deserved it. Score decreased accordingly.

Rating: 4/5

Score: B<1>

Leaderboard completion time: 06m24s

=cut
