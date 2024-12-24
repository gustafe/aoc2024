#! /usr/bin/env perl
# Advent of Code 2024 Day 24 - Crossed Wires - part 1
# https://adventofcode.com/2024/day/24
# https://gerikson.com/files/AoC2024/UNLICENSE
###########################################################
use Modern::Perl '2015';
# useful modules
use List::Util qw/sum any /;
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

my %wires;
my %gates;
my %ops = (
    AND => sub {
        if ( $_[0] == 1 and $_[1] == 1 ) {
            return 1;
        } else {
            return 0;
        }
    },
    OR => sub {
        if ( $_[0] == 0 and $_[1] == 0 ) {
            return 0;
        } else {
            return 1;
        }
    },
    XOR => sub {
        if ( $_[0] != $_[1] ) {
            return 1;
        } else {
            return 0;
        }
    },
);
for my $line (@input) {
    if ( $line =~ /^(...):\s+(0|1)$/ ) {
        $wires{$1} = $2;
    } elsif ( $line =~ /^(...) (AND|OR|XOR) (...) -> (...)$/ ) {
        $gates{$4} = { in1 => $1, in2 => $3, op => $2 };
        for my $w ( $1, $3, $4 ) {
            $wires{$w} = undef unless defined $wires{$w};
        }
    }
}
if ($testing) {

    for my $op (qw/AND OR XOR/) {
        for my $in ( [ 1, 1 ], [ 1, 0 ], [ 0, 1 ], [ 0, 0 ] ) {

            print join( ' ', $in->[0], $op, $in->[1] );
            say ": " . $ops{$op}->(@$in);
        }

    }
    dump \%gates;
    dump \%wires;
}
while ( any { !defined $wires{$_} } keys %wires ) {

    for my $k ( keys %gates ) {
        my ( $in1, $in2, $op ) = map { $gates{$k}->{$_} } qw/in1 in2 op/;
        if ( defined $wires{$in1} and defined $wires{$in2} ) {
            my $res = $ops{$op}->( $wires{$in1}, $wires{$in2} );
            $wires{$k} = $res;
        }
    }
}

my $binary_num;
for my $z ( sort grep { $_ =~ /^z/ } ( keys %wires ) ) {
    push @$binary_num, $wires{$z};
}
my $ans;
for ( my $exp = 0; $exp < scalar @$binary_num; $exp++ ) {
    $ans += $binary_num->[$exp] * 2**$exp;
}
### FINALIZE - tests and run time
is( $ans, 56278503604006, "Part 1: $ans" );
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

=head3 Day 24: Crossed Wires

=encoding utf8

Xmas eve with my parents visiting didn't leave time for more than part 1.

I had a lot of issues with the "binary". I tried using the Perl
built-in binary AND, OR and XOR, but got a lot of non-valid values for
some reason. Gave up and coded some slightly more complicated
comparisons.

Score: 1

Leaderboard completion time: 01h01m13s

=cut

