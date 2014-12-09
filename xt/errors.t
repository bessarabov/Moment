use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Exception;

use Moment;

sub main_in_test {

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
        qr{Incorrect usage\. new\(\) must get only one thing from the list: dt, timestamp or year/month/day/hour/minute/second\. Stopped at},
        'new( timestamp => ..., dt => ... )',
    );

    throws_ok(
        sub {
            my $n = Moment->now( 123 );
        },
        qr{Incorrect usage\. now\(\) shouldn't get any params. Stopped at},
        'now( 123 )',
    );

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

    done_testing;

}
main_in_test();
