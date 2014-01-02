#!/usr/bin/env perl

use feature qw(say);

use VM::JiffyBox;
use Data::Dumper;

unless ($ARGV[0]) {
    say 'Token as first argument needed!';
}

my $jiffy = VM::JiffyBox->new(token => $ARGV[0]);
my $dists;

if ( $ARGV[1] ) {
    $dists = $jiffy->plan_details( $ARGV[1] );
}
else {
    $dists = $jiffy->plans;
}

print Dumper $dists;

