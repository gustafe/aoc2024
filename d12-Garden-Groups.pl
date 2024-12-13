#! /usr/bin/env perl
# Advent of Code 2024 Day 12 - Garden Groups - part 1 
# https://adventofcode.com/2024/day/12
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
    for my $chr ( split( //, $line ) ) {
        $Map->{$r}{$c}{label} = $chr;
        $c++;
    }
    $r++;
}

# flood fill with different areas
my $area_id = 1;
my %dirs = ( N => [ -1, 0 ], S => [ 1, 0 ], W => [ 0, -1 ], E => [ 0, 1 ] );
for my $R ( sort { $a <=> $b } keys %$Map ) {
    for my $C ( sort { $a <=> $b } keys %{ $Map->{$R} } ) {
        next if $Map->{$R}{$C}{area_id};    # already seen and filled

        my $label = $Map->{$R}{$C}{label};
        $Map->{$R}{$C}{area_id} = $area_id;
        my @stack = ( [ $R, $C ] );
        my $filled;
        while (@stack) {
            my $curr = pop @stack;
            for my $d ( keys %dirs ) {
                my $rd = $curr->[0] + $dirs{$d}->[0];
                my $cd = $curr->[1] + $dirs{$d}->[1];
                if (    $Map->{$rd}{$cd}
                    and !$filled->{$rd}{$cd}
                    and $Map->{$rd}{$cd}{label} eq $label )
                {
                    $Map->{$rd}{$cd}{area_id} = $area_id;
                    $filled->{$rd}{$cd}++;
                    push @stack, [ $rd, $cd ];
                }
                if ( !$Map->{$rd}{$cd} or $Map->{$rd}{$cd}{label} ne $label )
                {    #border
                    $Map->{ $curr->[0] }{ $curr->[1] }{border}{$d}++;
                }
            }
        }
        $area_id++;
    }
}
my $count;
my $border_cells;

#my $corners;
for my $r ( sort { $a <=> $b } keys %$Map ) {
    for my $c ( sort { $a <=> $b } keys %{ $Map->{$r} } ) {
        $count->{ $Map->{$r}{$c}{label} }{ $Map->{$r}{$c}{area_id} }{area}++
            if $Map->{$r}{$c}{area_id};
        if ( $Map->{$r}{$c}{border} ) {
            if ( $testing and $Map->{$r}{$c}{area_id} == 5 ) {
                print STDERR "$r,$c: ";
                dump $Map->{$r}{$c};

            }

            # part 1
            $count->{ $Map->{$r}{$c}{label} }{ $Map->{$r}{$c}{area_id} }
                {perimeter} += scalar keys %{ $Map->{$r}{$c}{border} };
        }

    }
}
my $sum = 0;

for my $label ( keys %$count ) {

    for my $area_id ( keys %{ $count->{$label} } ) {

        $sum += $count->{$label}{$area_id}{area}
            * $count->{$label}{$area_id}{perimeter};
    }
}

### FINALIZE - tests and run time
if ( !$testing ) {
    is( $sum, 1446042, "Part 1: $sum" );
} else {

    is( $sum, 1930, "Part 1: $sum" );
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

=head3 Day 12: Garden Groups

=encoding utf8

Part 1 only for now.

I use flood-fill to fill out the different areas, and at the same time
I mark out if I find a border and in which direction it's facing. That
helped me find the perimiter, and is a good start for finding sides
(or rather corners), but I still need to figure out all the literal
edge cases.

Score: 1

Leaderboard completion time: 17m42s

=cut
