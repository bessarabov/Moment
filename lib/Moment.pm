package Moment;

# ABSTRACT: working with UTC based time

use strict;
use warnings FATAL => 'all';

=encoding UTF-8
=cut

=head1 SYNOPSIS

First you need to create and object with the constuctor new():

    my $some_moment = Moment->new(
        dt => '2014-11-27 03:31:23',
    );

    my $other_moment = Moment->new(
        year => 2014,
        month => 1,
        day => 3,

        hour => 4,
        minute => 2,
        second => 10,
    );

    my $one_more_moment = Moment->new(
        timestamp => 1000000000,
    );

Or you can use now() to create object that points to the current moment:

    my $now = Moment->now();

Then you can use this methods that return scalar values:

    # Unix time (a.k.a. POSIX time or Epoch time)
    my $number = $moment->get_timestamp();

    # '2014-11-27 03:31:23'
    my $dt = $moment->get_dt();

    my $year = $moment->get_year();
    my $month = $moment->get_month();
    my $day = $moment->get_day();
    my $hour = $moment->get_hour();
    my $minute = $moment->get_minute();
    my $second = $moment->get_second();

    # 'monday', 'tuesday' and others
    my $string = $moment->get_weekday_name();

Methods that return bool value:

    $moment->is_monday();
    $moment->is_tuesday();
    $moment->is_wednesday();
    $moment->is_thursday();
    $moment->is_friday();
    $moment->is_saturday();
    $moment->is_sunday();

    # returns true is the year of the moment is leap
    $moment->is_leap_year();

You can compare 2 objects (the method cmp() works exaclty as cmp operato and
returns -1, 0, or 1):

    my $result = $moment->cmp($moment2);

And you can create new objects:

    # create object with the moment '2014-11-01 00:00:00'
    my $moment = Moment->new(dt => '2014-11-27 03:31:23')->get_month_start();

    # create object with the moment '2014-11-30 23:59:59'
    my $moment = Moment->new(dt => '2014-11-27 03:31:23')->get_month_end();

    my $in_one_day = $moment->plus( day => 1 );
    my $one_year_before = $moment->minus( second => 1 );

=head1 DESCRIPTION

=over

=item * Class represents only UTC time, no timezone info

=item * Object orentied design

=item * Object can't be changed after creation

=item * The precise is one seond

=item * Working with dates in the period from '1800-01-01 00:00:00' to
'2199-12-31 23:59:59'

=item * Dies in case of any errors

=item * No dependencies, but perl

=item * Using SemVer for version numbers

=back

=cut

1;
