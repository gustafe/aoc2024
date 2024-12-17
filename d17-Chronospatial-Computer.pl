#! /usr/bin/env perl
# Advent of Code 2024 Day 17 - Chronospatial Computer - part 1
# https://adventofcode.com/2024/day/17
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
my $file = $testing ? 'test'.$testing.'.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my %registers;
my @program;
my @out;

for my $line (@input) {
    if ( $line =~ m/^Register (\S): (\d+)$/ ) {
        $registers{$1} = $2;
    } elsif ( $line =~ m/^Program: (.*)$/ ) {
        @program = split( /\,/, $1 );
    }
}

my %combo = (
    0 => sub { return 0 },
    1 => sub { return 1 },
    2 => sub { return 2 },
    3 => sub { return 3 },
    4 => sub { return $registers{A} },
    5 => sub { return $registers{B} },
    6 => sub { return $registers{C} },
    7 => sub { return undef }
);

my %ops = (
    0 => \&adv,
    1 => \&bxl,
    2 => \&bst,
    3 => \&jnz,
    4 => \&bxc,
    5 => \&out,
    6 => \&bdv,
    7 => \&cdv
);

dump \%registers;
dump \@program;
sub debug;
my $pnt = 0;

#debug();
while ( $pnt <= $#program ) {
    my ( $op, $arg ) = @program[ $pnt, $pnt + 1 ];
    printf( "op=%d arg=%d\n", $op, $arg ) if $testing;
    my $ret = $ops{$op}->($arg);
    if ( defined $ret ) {
        $pnt = $ret;
    } else {
        $pnt += 2;
    }
}
say "==> END <==";
debug();
my $ans = join( ',', @out );
### FINALIZE - tests and run time
is( $ans, '7,0,7,3,4,1,3,0,1', "Part 1: $ans" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub debug {
    printf( "pnt=%d A=%d B=%d C=%d\n",
        $pnt, map { $registers{$_} } qw/A B C/ );
    printf( "out=%s\n", join( ',', @out ) );
}

sub adv {
    my ($operand) = $combo{ $_[0] }->();

    my $num = $registers{A};
    my $den = 2**$operand;
    printf( "adv: num=%d den=%d\n", $num, $den ) if $testing;
    $registers{A} = int( $num / $den );
    return undef;
}

sub bxl {
    my ($operand) = @_;
    my $lhs = $registers{B};
    printf( "bxl: lhs=%d operand=%d res=%d\n",
        $lhs, $operand, $lhs ^ $operand )
        if $testing;
    $registers{B} = $lhs ^ $operand;
    return undef;
}

sub bst {
    my ($operand) = $combo{ $_[0] }->();
    printf("bst: \n") if $testing;
    $registers{B} = $operand % 8;
    return undef;
}

sub jnz {
    my ($operand) = @_;
    printf( "jnz: operand=%d A=%d\n", $operand, $registers{A} ) if $testing;
    if ( $registers{A} == 0 ) {
        return undef;
    } else {
        return $operand;
    }

}

sub bxc {
    my ($operand) = $combo{ $_[0] }->();
    printf( "bxc: B=%d C=%d res=%d",
        $registers{B}, $registers{C}, $registers{B} ^ $registers{C} )
        if $testing;
    $registers{B} = $registers{B} ^ $registers{C};

    return undef;
}

sub out {
    my ($operand) = $combo{ $_[0] }->();
    printf( "out: operand=%d output=%d\n", $operand, $operand % 8 )
        if $testing;
    push @out, $operand % 8;
    return undef;
}

sub bdv {
    my ($operand) = $combo{ $_[0] }->();
    my $num       = $registers{A};
    my $den       = 2**$operand;
    printf( "bdv: num=%d den=%d\n", $num, $den ) if $testing;
    $registers{B} = int( $num / $den );
    return undef;

}

sub cdv {
    my ($operand) = $combo{ $_[0] }->();
    my $num       = $registers{A};
    my $den       = 2**$operand;
    printf( "cdv: num=%d den=%d\n", $num, $den ) if $testing;
    $registers{C} = int( $num / $den );
    return undef;

}
sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}


###########################################################

=pod

=head3 Day 17: Chronospatial Computer

=encoding utf8

Part 1 only for now.

Score: 1

Leaderboard completion time: 44m39s

=cut

