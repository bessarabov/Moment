use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::MockTime qw( set_fixed_time );

use Moment;

sub main_in_test {

    set_fixed_time(0);

    is(
        Moment->now()->get_timestamp(),
        0,
        'mocked time is correct',
    );

    set_fixed_time(1417679729);

    is(
        Moment->now()->get_dt(),
        '2014-12-04 07:55:29',
        'mocked time is correct',
    );

    done_testing;

}
main_in_test();
