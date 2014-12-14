use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Exception;

use Moment;

sub test_new {
    throws_ok(
        sub { Moment->new(); },
        qr{Incorrect usage\. new\(\) must get some params: dt, timestamp or year/month/day/hour/minute/secod\. Stopped at},
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
                timestamp => undef,
            );
        },
        qr{Incorrect usage\. new\(\) must get one thing from the list: dt, timestamp or year/month/day/hour/minute/second\. Stopped at},
        'new( timestamp => undef )',
    );

    throws_ok(
        sub {
            my $n = Moment->new(
                timestamp => 'abc',
            );
        },
        qr{Incorrect usage\. The recieved timestamp is not an integer number. Stopped at},
        'new( timestamp => "abc" )',
    );

    throws_ok(
        sub {
            my $n = Moment->new(
                timestamp => 123.5,
            );
        },
        qr{Incorrect usage\. The recieved timestamp is not an integer number. Stopped at},
        'new( timestamp => 123.5 )',
    );

    throws_ok(
        sub {
            my $n = Moment->new(
                timestamp => 10_000_000_000,
            );
        },
        qr{Incorrect usage\. The recieved timestamp 10000000000 it too big\. It must be <= 7_258_118_399\. Stopped at},
        'new( timestamp => 10_000_000_000 )',
    );

    throws_ok(
        sub {
            my $n = Moment->new(
                timestamp => -10_000_000_000,
            );
        },
        qr{Incorrect usage\. The recieved timestamp -10000000000 it too low\. It must be >= -5_364_662_400\. Stopped at},
        'new( timestamp => -10_000_000_000 )',
    );

    throws_ok(
        sub {
            my $n = Moment->new(
                dt => '1799-12-31 23:59:59',
            );
        },
        qr{Incorrect usage\. Year 1799 it too low\. It must be >= 1800\. Stopped at},
        "new( dt => '1799-12-31 23:59:59' )",
    );

    throws_ok(
        sub {
            my $n = Moment->new(
                dt => '2200-01-01 00:00:00',
            );
        },
        qr{Incorrect usage\. Year 2200 it too big\. It must be <= 2199\. Stopped at},
        "new( dt => '2200-01-01 00:00:00' )",
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
        qr{Incorrect usage\. Year 1799 it too low\. It must be >= 1800\. Stopped at},
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
        qr{Incorrect usage\. Year 2200 it too big\. It must be <= 2199\. Stopped at},
        "new( year => 2200, ... )",
    );

}

sub test_now {
    throws_ok(
        sub {
            my $n = Moment->now( 123 );
        },
        qr{Incorrect usage\. now\(\) shouldn't get any params. Stopped at},
        'now( 123 )',
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

sub main_in_test {

    test_new();
    test_now();
    test_plus();
    test_minus();
    test_cmp();

    done_testing;

}
main_in_test();
