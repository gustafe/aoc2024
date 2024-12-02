#! /usr/bin/env perl
# Advent of Code 2024 Day 2 - Red-Nosed Reports - complete solution
# https://adventofcode.com/2024/day/2
# https://gerikson.com/files/AoC2024/UNLICENSE
###########################################################
use Modern::Perl '2015';
# useful modules
use List::Util qw/sum all any max/;
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
my %ans;
for my $line (@input) {
    my @report = split( /\s+/, $line );
    if ( report_is_safe(@report) ) {
        $ans{1}++;
    } else {
        say join( ' ', @report ) if $testing;
        my $oks = 0;
        for my $idx ( 0 .. $#report ) {
            my @copy = @report;
            splice( @copy, $idx, 1 );
            say join( ' ', @copy ) if $testing;
            $oks += report_is_safe(@copy);
        }
        $ans{2}++ if $oks > 0;
    }

}

### FINALIZE - tests and run time
is( $ans{1},           356, "Part 1: $ans{1}" );
is( $ans{1} + $ans{2}, 413, "Part 2: " . sum values %ans );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub report_is_safe {
    my @report = @_;
    my @diffs;
    my $ok = 0;
    for ( my $i = 1; $i <= $#report; $i++ ) {
        push @diffs, $report[$i] - $report[ $i - 1 ];
    }
    if ($testing) {
        say join( ' ', @report );
        say join( ' ', @diffs );
    }
    if ( ( all { $_ > 0 } @diffs or all { $_ < 0 } @diffs )
        and max( map { abs($_) } @diffs ) <= 3 )
    {
        $ok = 1;
    }
    say $ok? 'OK'  : 'NOK' if $testing;
    return $ok ? 1 : 0;

}

sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 2: Red-Nosed Reports

=encoding utf8

I'm sure there's a smarter way to handle part 2 than simply removing
each element and testing the result, but it's still fast enough for
this dataset.

Every year there’s a day when I have to use Perl’s C<splice> function,
and every year I stare at the man page in mystification. Where does
this syntax come from?!

Score: 2

Leaderboard completion time: 04m42s

=cut
