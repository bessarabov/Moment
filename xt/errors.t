use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Exception;

use Moment;

sub main_in_test {

    throws_ok(
        sub { Moment->new(); },
        qr{Incorrect usage\. new\(\) must get some params: dt, timestamp or year/month/day/hour/minute/secod\.},
        'new()',
    );

    throws_ok(
        sub {
            my $n = Moment->new(
                timestamp => 0,
                dt => "2014-12-05 00:00:00",
            );
        },
        qr{Incorrect usage\. new\(\) must get only one thing from the list: dt, timestamp or year/month/day/hour/minute/secod\.},
        'new( timestamp => ..., dt => ... )',
    );

    done_testing;

}
main_in_test();
