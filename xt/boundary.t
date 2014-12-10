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

    done_testing;

}
main_in_test();
