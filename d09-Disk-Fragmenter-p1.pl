#! /usr/bin/env perl
# Advent of Code 2024 Day 9 - Disk Fragmenter - part 1
# https://adventofcode.com/2024/day/9
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
sub dump_map;
my @diskmap = split(//,$input[0]);
my $Map;
my $seq=0;
my $file_id=0;
while (@diskmap) {
    my $data_len =shift @diskmap;
    my $free_len = shift @diskmap;
    $Map->{$seq} = {data => [ ($file_id) x $data_len ], free=>0 };
    $seq++;
    $file_id++;
    if ($free_len) {
	$Map->{$seq} = { data=>[], free=>$free_len} ;
    	$seq++;
    }

}
#dump $Map;


my @sectors = sort {$a<=>$b} keys %$Map;
#exit 0;
while (scalar @sectors > 2) {
    while ($Map->{$sectors[0]}{free}==0 )  {
	shift @sectors;
    }

    while (!@{$Map->{$sectors[-1]}{data}}) {
	pop @sectors
    }
    my $curr_free = $sectors[0];
    my $curr_data = $sectors[-1];

    my $free_space = $Map->{$curr_free}{free};
    while ($free_space and @{$Map->{$curr_data}{data}}) {
	push @{$Map->{$curr_free}{data}}, shift @{$Map->{$curr_data}{data}};
	$free_space--
    }
    $Map->{$curr_free}{free}=$free_space;
}
my @result;
for my $sec (sort {$a<=>$b} keys %$Map) {
    if (@{$Map->{$sec}{data}}) {
	push @result, @{$Map->{$sec}{data}};
    } else {
	push @result, (0);
    }

}
my $ans;
for  (my $idx=0; $idx<=$#result; $idx++) {
    $ans += $result[$idx] * $idx
}

### FINALIZE - tests and run time
is($ans,6332189866718,"Part 1: $ans");
done_testing();
say sec_to_hms(tv_interval($start_time));

### SUBS

sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}
