use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Exception;

use Moment;

sub main_in_test {

    throws_ok(
        sub { my $moment = Moment->new(iso_string => "2015-11-07T17:06:47Z\n"); },
        qr{Incorrect usage\. iso_string '.*' is not in expected format 'YYYY-MM-DDThh:mm:ssZ'\. Stopped}s,
        'new( iso_string => "...\n" ) throws exception',
    );

    throws_ok(
        sub { my $moment = Moment->new(dt => "2015-11-07 17:06:47\n"); },
        qr{Incorrect usage\. dt '.*' is not in expected format 'YYYY-MM-DD hh:mm:ss'\. Stopped}s,
        'new( dt => "...\n" ) throws exception',
    );

    throws_ok(
        sub {
            my $moment = Moment->new(
                year => "2015\n",
                month => 11,
                day => 7,
                hour => 17,
                minute => 6,
                second => 47,
            );
        },
        qr{Incorrect usage\. The year '.*' is not an integer number\. Stopped}s,
        'new( year => "2015\n", ... ) throws exception',
    );

    throws_ok(
        sub {
            my $moment = Moment->new(
                year => "2015",
                month => 11,
                day => 7,
                hour => "0\n",
                minute => 6,
                second => 47,
            );
        },
        qr{Incorrect usage\. The hour '.*' is not an integer number\. Stopped}s,
        'new( ..., hour => "0\n", ... ) throws exception',
    );

    done_testing;
}
main_in_test();
