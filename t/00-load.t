#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Jenkins::Config' ) || print "Bail out!\n";
}

diag( "Testing Jenkins::Config $Jenkins::Config::VERSION, Perl $], $^X" );
