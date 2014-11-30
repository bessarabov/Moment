use strict;
use warnings FATAL => 'all';
use Test::More;

use Moment;

sub main_in_test {

    is(
        Moment->new( dt => '2000-01-01 00:00:00' )->cmp(
            Moment->new( dt => '2001-01-01 00:00:00')
        ),
        -1,
        'cmp() -1'
    );

    is(
        Moment->new( dt => '2000-01-01 00:00:00' )->cmp(
            Moment->new( dt => '2000-01-01 00:00:00')
        ),
        0,
        'cmp() 0'
    );

    is(
        Moment->new( dt => '2000-01-01 00:00:00' )->cmp(
            Moment->new( dt => '1970-01-01 00:00:00')
        ),
        1,
        'cmp() 1'
    );

    done_testing;

}
main_in_test();
