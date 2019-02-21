use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Exception;

use Moment;

sub test_new {
    throws_ok(
        sub { Moment->new(); },
        qr{Incorrect usage\. new\(\) must get some params: dt, timestamp or year/month/day/hour/minute/second\. Stopped at},
        'new()',
    );

    throws_ok(
        sub { Moment->new( 123 ); },
        qr{Incorrect usage\. new\(\) must get hash like: `new\( timestamp => 0 \)`\. Stopped at},
        'new( 123 )',
    );

    throws_ok(
        sub { Moment->new( week => 4 ); },
        qr{Incorrect usage\. new\(\) got unknown params: 'week'\. Stopped at},
        'new( week => 4 )',
    );

    throws_ok(
        sub { Moment->new( week => 4, century => 8 ); },
        qr{Incorrect usage\. new\(\) got unknown params: 'century', 'week'\. Stopped at},
        'new( week => 4, century => 8 )',
    );

    throws_ok(
        sub { Moment->new( year => 2000, month => 8, day => 2 ); },
        qr{Must specify all params: year, month, day, hour, minute, second\. Stopped at},
        'new( year => 2000, month => 8, day => 2 )',
    );

    throws_ok(
        sub {
            my $n = Moment->new(
                timestamp => 0,
                dt => "2014-12-05 00:00:00",
            );
        },
        qr{Incorrect usage\. new\(\) must get one thing from the list: dt, timestamp or year/month/day/hour/minute/second\. Stopped at},
        'new( timestamp => ..., dt => ... )',
    );

    throws_ok(
        sub {
            my $n = Moment->new(
                year => 1799,
                month => 12,
                day => 31,
                hour => 23,
                minute => 59,
                second => 59,
            );
        },
        qr{Incorrect usage\. The year '1799' is not in range \[1800, 2199]\. Stopped at},
        "new( year => 1799, ... )",
    );

    throws_ok(
        sub {
            my $n = Moment->new(
                year => 2200,
                month => 1,
                day => 1,
                hour => 0,
                minute => 0,
                second => 0,
            );
        },
        qr{Incorrect usage\. The year '2200' is not in range \[1800, 2199]\. Stopped at},
        "new( year => 2200, ... )",
    );

    my $m = Moment->new( dt => '2000-01-01 00:00:00' );

    throws_ok(
        sub {
            my $m2 = $m->new(
                year => 2001,
                month => 1,
                day => 1,
                hour => 0,
                minute => 0,
                second => 0,
            );
        },
        qr{Incorrect usage\. You can't run new\(\) on a variable\. Stopped at},
        "$m->new( year => 2001, ... )",
    );

}

sub test_new_dt {

    my @tests = (
        {
            value => undef,
            error => "Incorrect usage. new() must get one thing from the list: dt, timestamp or year/month/day/hour/minute/second. Stopped at",
        },
        {
            value => '2000-1-1 23:59:59',
            error => "Incorrect usage. dt '2000-1-1 23:59:59' is not in expected format 'YYYY-MM-DD hh:mm:ss'. Stopped at",
        },
        {
            value => '1799-12-31 23:59:59',
            error => "Incorrect usage. The year '1799' is not in range [1800, 2199]. Stopped at",
        },
        {
            value => '2200-01-01 00:00:00',
            error => "Incorrect usage. The year '2200' is not in range [1800, 2199]. Stopped at",
        },
        {
            value => '2000-33-01 00:00:00',
            error => "Incorrect usage. The month '33' is not in range [1, 12]. Stopped at",
        },
        {
            value => '2014-02-29 00:00:00',
            error => "Incorrect usage. The day '29' is not in range [1, 28]. Stopped at",
        },
        {
            value => '2000-02-30 00:00:00',
            error => "Incorrect usage. The day '30' is not in range [1, 29]. Stopped at",
        },
    );

    foreach my $t (@tests) {
        eval {
            my $n = Moment->new(
                dt => $t->{value},
            );
        };

        my $safe_value = defined($t->{value}) ? $t->{value} : 'undef';

        my $test_name =  "new( dt => '$safe_value' )";

        # if $@ contains $t->{error}
        if (index($@, $t->{error}) != -1) {
            pass($test_name);
        } else {
            fail($test_name);
            note("Value:    $safe_value");
            note("Got:      $@");
            note("Expected: $t->{error}");
        }
    }

}

sub test_new_timestamp {

    my @tests = (
        {
            value => undef,
            error => "Incorrect usage. new() must get one thing from the list: dt, timestamp or year/month/day/hour/minute/second. Stopped at",
        },
        {
            value => 'abc',
            error => "Incorrect usage. The timestamp 'abc' is not an integer number. Stopped at",
        },
        {
            value => 123.5,
            error => "Incorrect usage. The timestamp '123.5' is not an integer number. Stopped at",
        },
        {
            value => 10_000_000_000,
            error => "Incorrect usage. The timestamp '10000000000' is not in range [-5364662400, 7258118399]. Stopped at",
        },
        {
            value => -10_000_000_000,
            error => "Incorrect usage. The timestamp '-10000000000' is not in range [-5364662400, 7258118399]. Stopped at",
        },
    );

    foreach my $t (@tests) {
        eval {
            my $n = Moment->new(
                timestamp => $t->{value},
            );
        };

        my $safe_value = defined($t->{value}) ? $t->{value} : 'undef';

        my $test_name =  "new( timestamp => '$safe_value' )";

        # if $@ contains $t->{error}
        if (index($@, $t->{error}) != -1) {
            pass($test_name);
        } else {
            fail($test_name);
            note("Value:    $safe_value");
            note("Got:      $@");
            note("Expected: $t->{error}");
        }
    }

}

sub test_new_iso_string {

    my @tests = (
        {
            value => undef,
            error => "Incorrect usage. new() must get one thing from the list: dt, timestamp or year/month/day/hour/minute/second. Stopped at",
        },
        {
            value => 'abc',
            error => "Incorrect usage. iso_string 'abc' is not in expected format 'YYYY-MM-DDThh:mm:ssZ",
        },
        {
            value => '2017-05-09T15:01:70Z',
            error => "Incorrect usage. The second '70' is not in range [0, 59]. Stopped at",
        },
    );

    foreach my $t (@tests) {
        eval {
            my $n = Moment->new(
                iso_string => $t->{value},
            );
        };

        my $safe_value = defined($t->{value}) ? $t->{value} : 'undef';

        my $test_name =  "new( iso_string => '$safe_value' )";

        # if $@ contains $t->{error}
        if (index($@, $t->{error}) != -1) {
            pass($test_name);
        } else {
            fail($test_name);
            note("Value:    $safe_value");
            note("Got:      $@");
            note("Expected: $t->{error}");
        }
    }

}

sub test_now {
    throws_ok(
        sub {
            my $n = Moment->now( 123 );
        },
        qr{Incorrect usage\. now\(\) shouldn't get any params. Stopped at},
        'now( 123 )',
    );

    my $m = Moment->new( dt => '2000-01-01 00:00:00' );

    throws_ok(
        sub {
            my $m2 = $m->now();
        },
        qr{Incorrect usage\. You can't run now\(\) on a variable\. Stopped at},
        "$m->now()",
    );
}

sub test_plus {
    throws_ok(
        sub { Moment->plus(); },
        qr{Incorrect usage\. plus\(\) must get some params. Stopped at},
        'plus()',
    );

    throws_ok(
        sub { Moment->plus( 123 ); },
        qr{Incorrect usage\. plus\(\) must get hash like: `plus\( hour => 1 \)`\. Stopped at},
        'plus( 123 )',
    );

    throws_ok(
        sub { Moment->plus( month => 1 ); },
        qr{Incorrect usage\. plus\(\) got unknown params: 'month'\. Stopped at},
        'plus( month => 1 )',
    );

    throws_ok(
        sub { Moment->plus( month => 1, year => 2, aa => 3 ); },
        qr{Incorrect usage\. plus\(\) got unknown params: 'aa', 'month', 'year'\. Stopped at},
        'plus( month => 1, year => 2, aa => 3 )',
    );

    throws_ok(
        sub { Moment->plus( day => 'aa' ); },
        qr{Incorrect usage\. plus\(\) must get integer for 'day'. Stopped at},
        "plus( day => 'aa' )",
    );

    throws_ok(
        sub { Moment->plus( hour => 'aa' ); },
        qr{Incorrect usage\. plus\(\) must get integer for 'hour'. Stopped at},
        "plus( hour => 'aa' )",
    );

    throws_ok(
        sub { Moment->plus( minute => 'aa' ); },
        qr{Incorrect usage\. plus\(\) must get integer for 'minute'. Stopped at},
        "plus( minute => 'aa' )",
    );

    throws_ok(
        sub { Moment->plus( second => 'aa' ); },
        qr{Incorrect usage\. plus\(\) must get integer for 'second'. Stopped at},
        "plus( second => 'aa' )",
    );
}

sub test_minus {
    throws_ok(
        sub { Moment->minus(); },
        qr{Incorrect usage\. minus\(\) must get some params. Stopped at},
        'minus()',
    );

    throws_ok(
        sub { Moment->minus( 123 ); },
        qr{Incorrect usage\. minus\(\) must get hash like: `minus\( hour => 1 \)`\. Stopped at},
        'minus( 123 )',
    );

    throws_ok(
        sub { Moment->minus( month => 1 ); },
        qr{Incorrect usage\. minus\(\) got unknown params: 'month'\. Stopped at},
        'minus( month => 1)',
    );

    throws_ok(
        sub { Moment->minus( month => 1, year => 2, aa => 3 ); },
        qr{Incorrect usage\. minus\(\) got unknown params: 'aa', 'month', 'year'\. Stopped at},
        'minus( month => 1, year => 2, aa => 3 )',
    );

    throws_ok(
        sub { Moment->minus( day => 'aa' ); },
        qr{Incorrect usage\. minus\(\) must get integer for 'day'. Stopped at},
        "minus( day => 'aa' )",
    );

    throws_ok(
        sub { Moment->minus( hour => 'aa' ); },
        qr{Incorrect usage\. minus\(\) must get integer for 'hour'. Stopped at},
        "minus( hour => 'aa' )",
    );

    throws_ok(
        sub { Moment->minus( minute => 'aa' ); },
        qr{Incorrect usage\. minus\(\) must get integer for 'minute'. Stopped at},
        "minus( minute => 'aa' )",
    );

    throws_ok(
        sub { Moment->minus( second => 'aa' ); },
        qr{Incorrect usage\. minus\(\) must get integer for 'second'. Stopped at},
        "minus( second => 'aa' )",
    );
}

sub test_cmp {

    my $moment_1 = Moment->new( dt => '2000-01-01 00:00:00');
    my $some_object = bless {}, 'Object';

    throws_ok(
        sub { $moment_1->cmp(); },
        qr{Incorrect usage\. cmp\(\) must get one parameter. Stopped at},
        '$moment_1->cmp();',
    );

    throws_ok(
        sub { $moment_1->cmp( undef ); },
        qr{Incorrect usage\. cmp\(\) must get Moment object as a parameter. Stopped at},
        '$moment_1->cmp( undef );',
    );

    throws_ok(
        sub { $moment_1->cmp( 123 ); },
        qr{Incorrect usage\. cmp\(\) must get Moment object as a parameter. Stopped at},
        '$moment_1->cmp( 123 );',
    );

    throws_ok(
        sub { $moment_1->cmp( { a => 1 } ); },
        qr{Incorrect usage\. cmp\(\) must get Moment object as a parameter. Stopped at},
        '$moment_1->cmp( { a => 1 } );',
    );

    throws_ok(
        sub { $moment_1->cmp( $some_object ); },
        qr{Incorrect usage\. cmp\(\) must get Moment object as a parameter. Stopped at},
        '$moment_1->cmp( $some_object );',
    );

    throws_ok(
        sub { $moment_1->cmp( 1, 2 ); },
        qr{Incorrect usage\. cmp\(\) must get one parameter. Stopped at},
        '$moment_1->cmp( 1, 2 );',
    );

}

sub test_methods_without_params {
    my $m = Moment->new( dt => '2000-01-01 00:00:00');

    my @methods = qw(
        get_iso_string
        get_timestamp
        get_dt
        get_d
        get_t
        get_year
        get_month
        get_day
        get_hour
        get_minute
        get_second
        get_weekday_name
        is_monday
        is_tuesday
        is_wednesday
        is_thursday
        is_friday
        is_saturday
        is_sunday
        is_leap_year
        get_month_start
        get_month_end
    );

    foreach my $method (@methods) {
        throws_ok(
            sub { $m->$method( 'asdf' ); },
            qr{Incorrect usage\. $method\(\) shouldn\'t get any params\. Stopped},
            "$method( 'asdf' ) dies, because it should not get param",
        );
    }
}

sub test_get_weekday_number {

    my $moment = Moment->new( dt => '2001-01-01 01:02:03');

    throws_ok(
        sub { $moment->get_weekday_number() },
        qr{Incorrect usage\. get_weekday_number\(\) must get param: first_day. Stopped at},
        'get_weekday_number() dies because it should get first_day param',
    );

    throws_ok(
        sub { $moment->get_weekday_number( 123 ) },
        qr{Incorrect usage\. get_weekday_number\(\) must get hash like: `get_weekday_number\( first_day => 'monday' \)`\. Stopped},
        'get_weekday_number() dies because it should get hash',
    );

    throws_ok(
        sub { $moment->get_weekday_number( incorrect_parameter => 123 ) },
        qr{Incorrect usage\. get_weekday_number\(\) got unknown params: 'incorrect_parameter'\. Stopped},
        'get_weekday_number() dies with incorrect parameter',
    );

    throws_ok(
        sub { $moment->get_weekday_number( first_day => 123 ) },
        qr{Incorrect usage\. get_weekday_number\(\) got unknown value '123' for first_day\. Stopped},
        'get_weekday_number() dies with incorrect value for first_day',
    );
}

sub main_in_test {

    test_new();
    test_new_dt();
    test_new_timestamp();
    test_new_iso_string();
    test_now();
    test_plus();
    test_minus();
    test_cmp();
    test_methods_without_params();
    test_get_weekday_number();

    done_testing;

}
main_in_test();
