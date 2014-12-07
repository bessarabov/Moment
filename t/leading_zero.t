use strict;
use warnings FATAL => 'all';
use Test::More;

use Moment;

sub main_in_test {

    my $moment = Moment->new(
        year => '2000',
        month => '01',
        day => '01',
        hour => '04',
        minute => '05',
        second => '06',
    );

    is($moment->get_year(), '2000', 'get_year()');
    is($moment->get_month(), '1', 'get_month()');
    is($moment->get_day(), '1', 'get_day()');
    is($moment->get_hour(), '4', 'get_hour()');
    is($moment->get_minute(), '5', 'get_minute()');
    is($moment->get_second(), '6', 'get_second()');

    done_testing;

}
main_in_test();
