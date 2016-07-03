use strict;
use warnings FATAL => 'all';
use Test::More;

# TODO remove Test::Most;
use Test::Most;
die_on_fail();

use Moment;

sub main_in_test {
    pass('Loaded ok');

    my $tests = [

        # [ [second, minute, hour, day, month, year], timestamp, description ]

        [ [59, 59, 23, 31, 11, 1969], -1, '-1' ],

        [ [0, 0, 0, 1, 0, 1970], 0, '0' ],
        [ [1, 0, 0, 1, 0, 1970], 1, '1 second' ],
        [ [0, 1, 0, 1, 0, 1970], 60, '1 minute' ],
        [ [0, 0, 1, 1, 0, 1970], 3600, '1 hour' ],
        [ [0, 0, 0, 2, 0, 1970], 86400, '1 day' ],

        [ [59, 59, 23, 31, 0, 1970], 2678399 ],

        [ [0, 0, 0, 1, 1, 1970], 2678400, '1 month' ],
        [ [0, 0, 0, 1, 2, 1970], 5097600, '2 months' ],
        [ [0, 0, 0, 1, 3, 1970], 7776000, '...' ],
        [ [0, 0, 0, 1, 4, 1970], 10368000 ],
        [ [0, 0, 0, 1, 5, 1970], 13046400 ],
        [ [0, 0, 0, 1, 6, 1970], 15638400 ],
        [ [0, 0, 0, 1, 7, 1970], 18316800 ],
        [ [0, 0, 0, 1, 8, 1970], 20995200 ],
        [ [0, 0, 0, 1, 9, 1970], 23587200 ],
        [ [0, 0, 0, 1, 10, 1970], 26265600 ],
        [ [0, 0, 0, 1, 11, 1970], 28857600 ],

        [ [0, 0, 0, 1, 0, 1971], 31536000, '1 year' ],
        [ [0, 0, 0, 1, 0, 1972], 63072000, '2 years' ],
        [ [0, 0, 0, 1, 0, 1973], 94694400, '3 years' ],
        [ [0, 0, 0, 1, 0, 1974], 126230400, '4 years' ],
        [ [0, 0, 0, 1, 0, 1975], 157766400, '5 years' ],
        [ [0, 0, 0, 1, 0, 1976], 189302400, '6 years' ],
        [ [0, 0, 0, 1, 0, 1977], 220924800, '7 years' ],
        [ [0, 0, 0, 1, 0, 1978], 252460800, '8 years' ],
        [ [0, 0, 0, 1, 0, 1979], 283996800, '9 years' ],
        [ [0, 0, 0, 1, 0, 1980], 315532800, '10 years' ],

        [ [25, 10, 20, 10, 0, 1992], 695074225 ],

        [ [37, 59, 18, 19, 10, 1995], 816807577 ],
        [ [43, 48, 17, 7, 0, 1995], 789500923 ],

        [ [0, 0, 0, 1, 0, 2000], 946684800 ],
        [ [0, 0, 0, 1, 0, 2001], 978307200 ],
        [ [0, 0, 0, 1, 0, 2008], 1199145600 ],
        [ [0, 0, 0, 1, 0, 2196], 7131888000 ],
        [ [0, 0, 0, 1, 1, 1999], 917827200 ],
        [ [0, 0, 0, 1, 1, 2000], 949363200 ],
        [ [0, 0, 0, 1, 10, 2014], 1414800000 ],
        [ [0, 0, 0, 1, 11, 2199], 7255440000 ],
        [ [0, 0, 0, 1, 6, 2014], 1404172800 ],
        [ [0, 0, 0, 24, 10, 2014], 1416787200 ],
        [ [0, 0, 0, 25, 10, 2014], 1416873600 ],
        [ [0, 0, 0, 26, 10, 2014], 1416960000 ],
        [ [0, 0, 0, 27, 10, 2014], 1417046400 ],
        [ [0, 0, 0, 28, 10, 2014], 1417132800 ],
        [ [0, 0, 0, 29, 10, 2014], 1417219200 ],
        [ [0, 0, 0, 30, 10, 2014], 1417305600 ],
        [ [0, 55, 12, 4, 10, 2012], 1352033700 ],
        [ [10, 44, 23, 29, 10, 2014], 1417304650 ],
        [ [12, 26, 4, 2, 10, 2010], 1288671972 ],
        [ [17, 12, 3, 22, 9, 1990], 656565137 ],
        [ [23, 31, 3, 27, 10, 2014], 1417059083 ],
        [ [28, 19, 20, 10, 10, 2011], 1320956368 ],
        [ [3, 2, 1, 1, 0, 2000], 946688523 ],
        [ [3, 2, 1, 28, 1, 1999], 920163723 ],
        [ [3, 2, 1, 29, 1, 2000], 951786123 ],
        [ [3, 2, 1, 3, 1, 1999], 918003723 ],
        [ [3, 2, 1, 3, 1, 2000], 949539723 ],
        [ [3, 2, 1, 3, 6, 2014], 1404349323 ],
        [ [40, 46, 1, 9, 8, 2001], 1000000000 ],
        [ [42, 25, 21, 6, 11, 2000], 976137942 ],
        [ [59, 59, 23, 28, 1, 1999], 920246399 ],
        [ [59, 59, 23, 29, 1, 2000], 951868799 ],
        [ [59, 59, 23, 30, 10, 2014], 1417391999 ],
        [ [59, 59, 23, 31, 0, 2000], 949363199 ],
        [ [59, 59, 23, 31, 6, 2014], 1406851199 ],

        [ [59, 59, 23, 31, 11, 2199], 7258118399 ],

#        [ [0, 0, 0, 1, 0, 1800], -5364662400 ],
#        [ [0, 0, 0, 1, 0, 1801], -5333126400 ],
#        [ [0, 0, 0, 1, 0, 1804], -5238518400 ],
#        [ [59, 59, 23, 31, 0, 1800], -5361984001 ],
    ];

    foreach my $test (@{$tests}) {
        my @params = @{$test->[0]};
        my $timestamp = $test->[1];
        my $description;
        if (defined $test->[2]) {
            $description = '(' . $test->[2] . ")\t";
        } else {
            $description = '';
        }

        my $got = Moment::_timegm_nocheck(@params);

        my $result = is(
            $got,
            $timestamp,
            sprintf
                # [ [second, minute, hour, day, month, year], [timestamp] ]
                "%04d-%02d-%02dT%02d:%02d:%02dZ => %i\t%s[%s]",
                $params[5],
                $params[4] + 1,
                $params[3],
                $params[2],
                $params[1],
                $params[0],
                $timestamp,
                $description,
                join(', ', @params),
        );
        if (not $result) {
            note sprintf "diff: %i seconds, %s days",
                    ($got - $timestamp),
                    ($got - $timestamp) / 86400,
                ;
            note sprintf "is_leap_year(%s) => %s",
                $params[5],
                Moment::_is_leap_year( undef, $params[5] ) ? 'true' : 'false',
                ;
        }
    }

    done_testing;
}
main_in_test();