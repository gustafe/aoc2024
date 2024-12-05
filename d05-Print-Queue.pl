#! /usr/bin/env perl
# Advent of Code 2024 Day 5 - Print Queue - complete solution
# https://adventofcode.com/2024/day/5
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
my $rules;
my @updates;
for my $line (@input) {
    if ( $line =~ m/^(\d+)\|(\d+)$/ ) {
        $rules->{$1}{$2}++;
    } elsif ( $line =~ m/^\d+\,\d+/ ) {
        push @updates, [ split( /\,/, $line ) ];
    }
}

if ($testing) {
    dump $rules;
    dump @updates;
}
my %sums;
my @recheck;
for my $item (@updates) {
    my @current = @$item;
    my $ret     = check_item($item);

    printf(
        "%3s i=%2d j=%2d lix=%2d %s\n",
        $ret->{ok} ? 'OK' : 'NOK',
        $ret->{i}, $ret->{j}, $#current, join( ',', @current )
    ) if ( !$ret->{ok} and $testing );
    $sums{1} += $current[ $#current / 2 ] if $ret->{ok};
    # items that are not ok in this pass are stored in recheck array
    push @recheck, { ret => $ret, list => $item } if !$ret->{ok};

}
say "Recheck array size: ", scalar @recheck;
my $pass=0;
while (@recheck) {

    my $item = shift @recheck;
    dump $item if $testing;
    my @current = @{ $item->{list} };

    say join( ',', @current ) if $testing;
    # switch positions of the elements that were returned by the check_item sub and try again
    my @copy = @current;
    $current[ $item->{ret}{i} ] = $copy[ $item->{ret}{j} ];
    $current[ $item->{ret}{j} ] = $copy[ $item->{ret}{i} ];
    say join( ',', @current ) if $testing;

    my $ret = check_item( \@current );

    if ( $ret->{ok} ) {
        $sums{2} += $current[ $#current / 2 ];
        next;
    }
    # didn't pass, back into recheck array 
    push @recheck, { ret => $ret, list => \@current };
    $pass++;

}

say "All rechecks passed after $pass passes";
### FINALIZE - tests and run time
is( $sums{1}, 5991, "Part 1: $sums{1}" );
is( $sums{2}, 5479, "Part 2: $sums{2}" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS

sub check_item {
    # given a reference to a list, check that each element has only
    # legal successors according to the rules

    # return: current starting index, current ending index, status (ok, !ok) in a hashref
    
    my ($item) = @_;
    my @list   = @$item;
    my $ok     = 1;
    my $return;
CHECK:
    for ( my $i = 0; $i < $#list; $i++ ) {
        for ( my $j = $i + 1; $j <= $#list; $j++ ) {
            $return->{i} = $i;
            $return->{j} = $j;
            if ( !exists $rules->{ $list[$i] }{ $list[$j] } ) {
                $ok = 0;

                last CHECK;
            }
        }
    }
    $return->{ok} = $ok;
    return $return;
}

sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 5: Print Queue

=encoding utf8

This took me longer than it should have. I'll use yesterday's office
Christmas dinner as an excuse.

I could have tried to figure out a smarter way to sort each list
according to the rules... or I could just repeatedly switch elements I
know don't fit in until everything is ok. Runtime is less than a
second anyway.

Score: 2

Leaderboard completion time: 03m43s

=cut
