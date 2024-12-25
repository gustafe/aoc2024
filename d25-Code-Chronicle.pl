#! /usr/bin/env perl
# Advent of Code 2024 Day 25 - Code Chronicle - complete solution
# https://adventofcode.com/2024/day/25
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
my $item_id = 1;
my $line_no = 1;
my $data;
for my $line (@input) {
    push @{ $data->{$item_id} }, [ split( //, $line ) ] if $line_no % 8;
    $item_id++ if ( $line_no % 8 == 0 );

    $line_no++;
}
my %locks;
my %keys;
for my $item_id ( sort keys %$data ) {

    # check top and bottom
    if ( all { $_ eq '#' } @{ $data->{$item_id}[0] } ) {    # lock
        say "$item_id is lock" if $testing;
        for my $idx ( 1 .. 6 ) {
            for ( my $j = 0; $j < scalar @{ $data->{$item_id}[$idx] }; $j++ )
            {
                $locks{$item_id}->[$j]++ if $data->{$item_id}[$idx][$j] eq '#';
            }
        }
    } elsif ( all { $_ eq '#' } @{ $data->{$item_id}[6] } ) {    # key
        say "$item_id is key" if $testing;
        for my $idx ( 0 .. 5 ) {
            for ( my $j = 0; $j < scalar @{ $data->{$item_id}[$idx] }; $j++ )
            {
                $keys{$item_id}->[$j]++ if $data->{$item_id}[$idx][$j] eq '#';
            }
        }
    } else {
        die "can't recognize data item: $item_id";
    }
}
my $count = 0;
for my $lock_id ( sort keys %locks ) {
    for my $key_id ( sort keys %keys ) {
        my @lock_pins = @{ $locks{$lock_id} };
        my @key_pins  = @{ $keys{$key_id} };
        my @sums;
        for ( my $i = 0; $i <= $#lock_pins; $i++ ) {
            no warnings 'uninitialized';
            $sums[$i] = $lock_pins[$i] + $key_pins[$i];
        }
        $count++ if all { $_ <= 5 } @sums;
    }
}
### FINALIZE - tests and run time
is($count,2900,"Part 1: $count");
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

=head3 Day 25: Code Chronicle

=encoding utf8

Traditionally easy Christmas Day puzzle. 6 stars to go to get them all!

Score: 1

Leaderboard completion time: 04m43s

=cut

