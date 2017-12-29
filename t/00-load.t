#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'ptrbc' ) || print "Bail out!\n";
}

diag( "Testing ptrbc $ptrbc::VERSION, Perl $], $^X" );
