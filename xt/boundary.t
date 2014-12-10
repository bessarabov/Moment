use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Exception;

use Moment;

sub main_in_test {

    dies_ok( sub { Moment->new( timestamp => -5_364_662_402 ); }, '-5_364_662_402 dies' );
    dies_ok( sub { Moment->new( timestamp => -5_364_662_401); }, '-5_364_662_401 dies' );
    lives_ok( sub { Moment->new( timestamp => -5_364_662_400); }, '-5_364_662_400 lives' );
    lives_ok( sub { Moment->new( timestamp => -5_364_662_399); }, '-5_364_662_399 lives' );

    lives_ok( sub { Moment->new( timestamp => 7_258_118_398); }, '7_258_118_398 lives' );
    lives_ok( sub { Moment->new( timestamp => 7_258_118_399); }, '7_258_118_399 lives' );
    dies_ok( sub { Moment->new( timestamp => 7_258_118_400); }, '7_258_118_400 dies' );
    dies_ok( sub { Moment->new( timestamp => 7_258_118_401); }, '7_258_118_401 dies' );


    dies_ok( sub { Moment->new( dt => '1799-12-31 23:59:58'); }, '1799-12-31 23:59:58 dies' );
    dies_ok( sub { Moment->new( dt => '1799-12-31 23:59:59'); }, '1799-12-31 23:59:59 dies' );
    lives_ok( sub { Moment->new( dt => '1800-01-01 00:00:00'); }, '1800-01-01 00:00:00 lives' );
    lives_ok( sub { Moment->new( dt => '1800-01-01 00:00:01'); }, '1800-01-01 00:00:01 lives' );

    lives_ok( sub { Moment->new( dt => '2199-12-31 23:59:58'); }, '2199-12-31 23:59:58 lives' );
    lives_ok( sub { Moment->new( dt => '2199-12-31 23:59:59'); }, '2199-12-31 23:59:59 lives' );
    dies_ok( sub { Moment->new( dt => '2200-01-01 00:00:00'); }, '2200-01-01 00:00:00 dies' );
    dies_ok( sub { Moment->new( dt => '2200-01-01 00:00:01'); }, '2200-01-01 00:00:01 dies' );


    dies_ok( sub { Moment->new( year => 1799, month => 12, day => 31, hour => 23, minute => 59, second => 58); }, '1799-12-31 23:59:58 dies' );
    dies_ok( sub { Moment->new( year => 1799, month => 12, day => 31, hour => 23, minute => 59, second => 59); }, '1799-12-31 23:59:59 dies' );
    lives_ok( sub { Moment->new( year => 1800, month => 1, day => 1, hour => 0, minute => 0, second => 0); }, '1800-01-01 00:00:00 lives' );
    lives_ok( sub { Moment->new( year => 1800, month => 1, day => 1, hour => 0, minute => 0, second => 1); }, '1800-01-01 00:00:01 lives' );

    lives_ok( sub { Moment->new( year => 2199, month => 12, day => 31, hour => 23, minute => 59, second => 58); }, '2199-12-31 23:59:58 lives' );
    lives_ok( sub { Moment->new( year => 2199, month => 12, day => 31, hour => 23, minute => 59, second => 59); }, '2199-12-31 23:59:59 lives' );
    dies_ok( sub { Moment->new( year => 2200, month => 1, day => 1, hour => 0, minute => 0, second => 0); }, '2200-01-01 00:00:00 dies' );
    dies_ok( sub { Moment->new( year => 2200, month => 1, day => 1, hour => 0, minute => 0, second => 1); }, '2200-01-01 00:00:01 dies' );

    done_testing;

}
main_in_test();
