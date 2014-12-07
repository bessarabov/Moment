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
        sub { Moment->minus(); },
        qr{Incorrect usage\. minus\(\) must get some params. Stopped at},
        'minus()',
    );

    throws_ok(
        sub { Moment->minus( 123 ); },
        qr{Incorrect usage\. minus\(\) must get hash like: `minus\( hour => 1 \)`\. Stopped at},
        'minus( 123 )',
    );

    done_testing;

}
main_in_test();
