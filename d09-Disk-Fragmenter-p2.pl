#! /usr/bin/env perl
# Advent of Code 2024 Day 9 - Disk Fragmenter - part 2
# https://adventofcode.com/2024/day/9
# https://gerikson.com/files/AoC2024/UNLICENSE
###########################################################

use Modern::Perl '2015';
# useful modules
use List::Util qw/sum all min/;
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
my $hole_map;
while (@diskmap) {
    my $data_len =shift @diskmap;
    my $free_len = shift @diskmap;
    $Map->{$seq} = {data => [ ($file_id) x $data_len ] };
    $seq++;
    $file_id++;
    if ($free_len) {
	$Map->{$seq} = { data=>[('.') x $free_len ]} ;
	# we store a map of gaps, indexed by size and with positions as keys
	$hole_map->{$free_len}{$seq}++;
    	$seq++;
    }

}
dump $Map if $testing;
dump $hole_map if $testing;
my @reverse = sort {$b<=>$a} keys %$Map;

for my $block (@reverse) {
    dump $hole_map if $testing;
    say "testing $block" if $block % 1_000 ==0;

    next if (all {$_ eq '.'} @{$Map->{$block}{data}} );
    # what size do we need?
    my $wanted = scalar @{$Map->{$block}{data}};
    my $candidates;
    # find min sequence that can fit the data 
    for my $size (keys %$hole_map) {
	next if $size<$wanted;
	$candidates->{min keys %{$hole_map->{$size}}} = $size if %{$hole_map->{$size}};
    }
    next unless $candidates;
    my $leftmost = min keys %$candidates;
    my $collection = $candidates->{$leftmost};
    # remove this gap from the collection
    delete $hole_map->{$collection}{$leftmost};
	
    
    next if $leftmost>=$block;
	
    say "found candidate at $leftmost" if $testing;
    my @target = @{$Map->{$leftmost}{data}};
    my @source = @{$Map->{$block}{data}};
    my $moved_elems = scalar @source;
    for (my $idx =0; $idx<=$#target;$idx++) {
	if ($target[$idx] eq '.') {
	    $target[$idx] = shift @source if @source;
	}

    }
    $Map->{$leftmost}{data} = \@target;
    $Map->{$block}{data} = [('.') x $moved_elems]; # assume we have consumed everything
    my $holesize = scalar( grep {$_ eq '.'} @target); # if we have gaps left, add them to the map
    $hole_map->{$holesize}{$leftmost}++ if $holesize;
}
dump $Map if $testing;
my @result;
for my $block (sort {$a<=>$b} keys %$Map) {
    push @result, map {$_ eq '.'?0:$_ } @{$Map->{$block}{data}};
}
my $ans;
for (my $idx=0;$idx<=$#result; $idx++) {
    $ans += $result[$idx] * $idx;
}
#say $ans;

### FINALIZE - tests and run time
 is($ans,6353648390778, "Part 2: $ans");
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

=head3 Day 9: Disk Fragmenter

=encoding utf8

I'm usually pretty careful when copying the puzzle input, but today the buffer size on macOS Terminal failed me. It was only after comparing my algo with some on the subreddit that I figured out I was right all along.

Part 2 was straightforward but slow until I put in some auxilary hashes to keep  track of the gaps.

Score: 2

Leaderboard completion time: 14m05s

=cut
