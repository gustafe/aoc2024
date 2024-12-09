#! /usr/bin/env perl
# Advent of Code 2024 Day 9 - Disk Fragmenter - complete solution
# https://adventofcode.com/2024/day/9
# https://gerikson.com/files/AoC2024/UNLICENSE
###########################################################

use Modern::Perl '2015';
# useful modules
use List::Util qw/sum min all/;
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
my $Map1;
my $Map2;
my $gap_map;
my $seq=0;
my $file_id=0;
while (@diskmap) {
    my $data_len =shift @diskmap;
    my $free_len = shift @diskmap;
    $Map1->{$seq} = {data => [ ($file_id) x $data_len ], free=>0 };
    $Map2->{$seq} = {data => [ ($file_id) x $data_len ]};
    $seq++;
    $file_id++;
    if ($free_len) {
	$Map1->{$seq} = { data=>[], free=>$free_len} ;
	$Map2->{$seq} = { data=>[('.') x $free_len ]} ;
	# we store a map of gaps, indexed by size and with positions as keys
	$gap_map->{$free_len}{$seq}++;
    	$seq++;
    }

}
### Part 1 
my @sectors = sort {$a<=>$b} keys %$Map1;

while (scalar @sectors > 2) {
    while ($Map1->{$sectors[0]}{free}==0 )  {
	shift @sectors;
    }

    while (!@{$Map1->{$sectors[-1]}{data}}) {
	pop @sectors
    }
    my $curr_free = $sectors[0];
    my $curr_data = $sectors[-1];

    my $free_space = $Map1->{$curr_free}{free};
    while ($free_space and @{$Map1->{$curr_data}{data}}) {
	push @{$Map1->{$curr_free}{data}}, shift @{$Map1->{$curr_data}{data}};
	$free_space--
    }
    $Map1->{$curr_free}{free}=$free_space;
}
my @result1;
for my $sec (sort {$a<=>$b} keys %$Map1) {
    if (@{$Map1->{$sec}{data}}) {
	push @result1, @{$Map1->{$sec}{data}};
    } else {
	push @result1, (0);
    }

}
my $ans;
for  (my $idx=0; $idx<=$#result1; $idx++) {
    $ans->{1} += $result1[$idx] * $idx
}


is($ans->{1},6332189866718,"Part 1: $ans->{1}");

say sec_to_hms(tv_interval($start_time));

### Part 2
say "Solving part 2, please be patient...";
my @reverse = sort {$b<=>$a} keys %$Map2;

for my $block (@reverse) {
    if ($block % 1_000==0) {
	printf("handling block %5d. Gap map:\n", $block);
	print map { sprintf(" %d: %3d, ", $_, scalar keys %{$gap_map->{$_}}) } (1..9);
	print "\n";
    }


    next if (all {$_ eq '.'} @{$Map2->{$block}{data}} );
    # what size do we need?
    my $wanted = scalar @{$Map2->{$block}{data}};
    my $candidates;
    # find min sequence that can fit the data 
    for my $size (keys %$gap_map) {
	next if $size<$wanted;
	$candidates->{min keys %{$gap_map->{$size}}} = $size if %{$gap_map->{$size}};
    }
    next unless $candidates;
    my $leftmost = min keys %$candidates;
    my $collection = $candidates->{$leftmost};
    # remove this gap from the collection
    delete $gap_map->{$collection}{$leftmost};

    next if $leftmost>=$block;

    say "found candidate at $leftmost" if $testing;
    my @target = @{$Map2->{$leftmost}{data}};
    my @source = @{$Map2->{$block}{data}};
    my $moved_elems = scalar @source;
    for (my $idx =0; $idx<=$#target;$idx++) {
	if ($target[$idx] eq '.') {
	    $target[$idx] = shift @source if @source;
	}
    }
    $Map2->{$leftmost}{data} = \@target;
    $Map2->{$block}{data} = [('.') x $moved_elems]; # assume we have consumed everything
    my $gapsize = scalar( grep {$_ eq '.'} @target); # if we have gaps left, add them to the map
    $gap_map->{$gapsize}{$leftmost}++ if $gapsize;
}

my @result2;
for my $block (sort {$a<=>$b} keys %$Map2) {
    push @result2, map {$_ eq '.'?0:$_ } @{$Map2->{$block}{data}};
}

for (my $idx=0;$idx<=$#result2; $idx++) {
    $ans->{2} += $result2[$idx] * $idx;
}

### FINALIZE - tests and run time
 is($ans->{2},6353648390778, "Part 2: $ans->{2}");
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

I'm usually pretty careful when copying the puzzle input, but today
the buffer size on macOS Terminal failed me. It was only after
comparing my algo with some on the subreddit that I figured out I was
right all along.

Part 2 was straightforward but slow until I put in some auxilary
hashes to keep track of the gaps.

The two solutions share a common-ish data structure but quite
different algorithms. I'm usually not a huge fan of copy-paste between
the 2 parts but in this case I couldn't really be bothered with trying
to reconcile them style-wise.

Rating: 4/5, nice brain teaser and satisfying to solve. 

Score: 2

Leaderboard completion time: 14m05s

=cut
