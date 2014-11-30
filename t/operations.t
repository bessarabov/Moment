use strict;
use warnings FATAL => 'all';
use Test::More;

use Moment;

sub main_in_test {

    my $m1 = Moment->new( dt => '2014-11-30 23:59:59' );
    is(
        $m1->plus( second => 1 )->get_dt(),
        '2014-11-30 23:59:59',
        'plus( second => 1 )',
    );

    my $m1 = Moment->new( dt => '2000-00-00 00:00:00' );
    is(
        $m1->minus( second => 1 )->get_dt(),
        '1999-12-31 23:59:59',
        'minus( second => 1 )',
    );

    done_testing;

}
main_in_test();
