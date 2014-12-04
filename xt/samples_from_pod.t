use strict;
use warnings FATAL => 'all';
use Test::More;

use Test::MockTime qw( set_fixed_time );
use Capture::Tiny ':all';

use Moment;

sub say {
    print $_[0] . "\n";
}

sub get_month_last_day {

    my $day = Moment->now()->get_month_end()->get_day();

    is($day, 31, 'december 2014 has 31 days');
}

sub loop_through_month {

    my $got_output = capture_merged {
        my $start = Moment->now()->get_month_start();
        my $end = $start->get_month_end();

        my $current = $start;
        while ( $current->cmp($end) == -1 ) {
            say $current->get_day();
            $current = $current->plus( day => 1 );
        }
    };

    my $expected_output = join '', map { "$_\n" } (1..31);

    is($got_output, $expected_output, 'got expected output for looping throught month');

}

sub get_weekday_name_for_date {

    my $weekday = Moment->new( dt => '2014-01-01 00:00:00' )->get_weekday_name();

    is($weekday, 'wednesday', '2014-01-01 is wednesday');
}

sub number_of_seconds_in_day {

    my $moment = Moment->now();
    my $seconds_in_a_day = $moment->get_timestamp() - $moment->minus( day => 1 )->get_timestamp();

    is($seconds_in_a_day, 86400, 'a day has 86400 seconds');
}

sub main_in_test {

    # 2014-12-04 19:40:00
    set_fixed_time(1417722000);

    get_month_last_day();
    loop_through_month();
    get_weekday_name_for_date();
    number_of_seconds_in_day();

    done_testing;

}
main_in_test();
