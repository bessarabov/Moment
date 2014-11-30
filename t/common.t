use strict;
use warnings FATAL => 'all';
use Test::More;

use Moment;

sub main_in_test {

    my $dt = '2014-11-29 23:44:10';
    my $moment = Moment->new( dt => $dt );

    is($moment->get_timestamp(), '1417304650', 'get_timestamp()');
    is($moment->get_dt(), $dt, 'get_dt()');

    is($moment->get_year(), 2014, 'get_year()');
    is($moment->get_month(), 11, 'get_month()');
    is($moment->get_day(), 29, 'get_day()');
    is($moment->get_hour(), 23, 'get_hour()');
    is($moment->get_minute(), 44, 'get_minute()');
    is($moment->get_second(), 10, 'get_second()');

    ok($moment->is_saturday(), 'is_saturday()'));
    is($moment->get_weekday_name(), 'saturday');

    is($moment->get_month_start()->get_dt(), '2014-11-01 00:00:00', 'get_month_start()');
    is($moment->get_month_end()->get_dt(), '2014-11-30 23:59:59', 'get_month_start()');

    done_testing;

}
main_in_test();
