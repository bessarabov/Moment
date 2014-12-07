use strict;
use warnings FATAL => 'all';
use Test::More;

use Moment;

sub main_in_test {

    my $tests = [
        {
            dt => '2014-11-29 23:44:10',
            timestamp => 1417304650,
            year => 2014,
            month => 11,
            day => 29,
            hour => 23,
            minute => 44,
            second => 10,
            weekday => 'saturday',
            month_start_dt => '2014-11-01 00:00:00',
            month_end_dt => '2014-11-30 23:59:59',
        },
        {
            dt => '2014-07-03 01:02:03',
            timestamp => 1404349323,
            year => 2014,
            month => 7,
            day => 3,
            hour => 1,
            minute => 2,
            second => 3,
            weekday => 'thursday',
            month_start_dt => '2014-07-01 00:00:00',
            month_end_dt => '2014-07-31 23:59:59',
        }
    ];

    foreach my $test (@{$tests}) {
        my $moments = [
            Moment->new( timestamp => $test->{timestamp} ),
            Moment->new( dt => $test->{dt} ),
            Moment->new(
                year => $test->{year},
                month => $test->{month},
                day => $test->{day},
                hour => $test->{hour},
                minute => $test->{minute},
                second => $test->{second},
            ),
        ];

        foreach my $moment (@{$moments}) {
            is($moment->get_timestamp(), $test->{timestamp}, 'get_timestamp()');
            is($moment->get_dt(), $test->{dt}, 'get_dt()');

            is($moment->get_year(), $test->{year}, 'get_year()');
            is($moment->get_month(), $test->{month}, 'get_month()');
            is($moment->get_day(), $test->{day}, 'get_day()');
            is($moment->get_hour(), $test->{hour}, 'get_hour()');
            is($moment->get_minute(), $test->{minute}, 'get_minute()');
            is($moment->get_second(), $test->{second}, 'get_second()');

            is($moment->get_weekday_name(), $test->{weekday}, 'get_weekday_name()');

            is($moment->get_month_start()->get_dt(), $test->{month_start_dt}, 'get_month_start()');
            is($moment->get_month_end()->get_dt(), $test->{month_end_dt}, 'get_month_end()');
        }

    }


    done_testing;

}
main_in_test();
