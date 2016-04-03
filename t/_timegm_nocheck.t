use strict;
use warnings FATAL => 'all';

use Test::More;

use Moment;

sub main_in_test {

    pass('Loaded ok');
    my $now = Moment->now();

#    is($now->_timegm_nocheck(0, 0, 0, 1, 0, 1800), -5364662400);
    is($now->_timegm_nocheck(0, 0, 0, 1, 0, 1970), 0);
    is($now->_timegm_nocheck(23, 37, 16, 1, 0, 1970), 59843);
    is($now->_timegm_nocheck(37, 45, 12, 5, 0, 1970), 391537);
    is($now->_timegm_nocheck(37, 45, 12, 5, 1, 1970), 3069937);
    is($now->_timegm_nocheck(0, 0, 0, 1, 0, 1971), 31536000);
    is($now->_timegm_nocheck(0, 0, 0, 1, 0, 1972), 63072000);
    is($now->_timegm_nocheck(0, 0, 0, 1, 0, 1973), 94694400);
    is($now->_timegm_nocheck(0, 0, 0, 1, 0, 1974), 126230400);
    is($now->_timegm_nocheck(0, 0, 0, 1, 0, 1975), 157766400);
#    is($now->_timegm_nocheck(0, 0, 0, 1, 0, 2001), 978307200);
#    is($now->_timegm_nocheck(40, 46, 1, 9, 8, 2001), 1000000000);
#    is($now->_timegm_nocheck(23, 37, 16, 3, 3, 2016), 1459701443);
#    is($now->_timegm_nocheck(59, 59, 23, 31, 11, 2199), 7258118399);

    done_testing();
}
main_in_test();
