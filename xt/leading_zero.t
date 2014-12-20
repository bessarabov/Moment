use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Exception;

use Moment;

sub main_in_test {

    throws_ok(
        sub {
            my $moment = Moment->new(
                year => '2000',
                month => '01',
                day => '01',
                hour => '04',
                minute => '05',
                second => '06',
            );
        },
        qr{Incorrect usage\. The month '01' is not an integer number\. Stopped at},
        'plus( month => 1 )',
    );

    done_testing;

}
main_in_test();
