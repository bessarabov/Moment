package Moment;

# ABSTRACT: class that represents the moment in time

use strict;
use warnings FATAL => 'all';

use Carp;
use Time::Local;
use Time::Piece;
use Scalar::Util qw(blessed);

=encoding UTF-8
=cut

=head1 SYNOPSIS

Moment is a Perl library. With this library you can create object that
represent some moment in time.

There are 3 ways you can create new object with the new() constuctor:

    my $some_moment = Moment->new(
        # dt format is 'YYYY-MM-DD hh:mm:ss'
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
        # Unix time (a.k.a. POSIX time or Epoch time)
        timestamp => 1000000000,
    );

You can also use now() constroctor to create object that points to the current
moment in time:

    my $now = Moment->now();

When you have an object you can you use methods from it.

Here are the methods to get the values that was used in constructor:

    #'2014-11-27 03:31:23'
    my $dt = $moment->get_dt();

    my $year = $moment->get_year();
    my $month = $moment->get_month();
    my $day = $moment->get_day();
    my $hour = $moment->get_hour();
    my $minute = $moment->get_minute();
    my $second = $moment->get_second();

    # Unix time (a.k.a. POSIX time or Epoch time)
    my $number = $moment->get_timestamp();

You can find out what is the day of week of the moment that is stored in the
object. You can get scalar with the weekday name:

    # 'monday', 'tuesday' and others
    my $string = $moment->get_weekday_name();

Or you can test if the weekday of the moment is some specified weekday:

    $moment->is_monday();
    $moment->is_tuesday();
    $moment->is_wednesday();
    $moment->is_thursday();
    $moment->is_friday();
    $moment->is_saturday();
    $moment->is_sunday();

You can test if the year of the moment is leap with the method:

    $moment->is_leap_year();

If you have 2 Moment objects you can compare them with the cmp() method. The
method cmp() works exaclty as cmp builtin keyword and returns -1, 0, or 1:

    my $result = $moment_1->cmp($moment_2);

The Moment object is immutable. You can't change it after it is created. But
you can create new objects with the methods plus(), minus() and
get_month_start(), get_month_end():

    my $in_one_day = $moment->plus( day => 1 );
    my $ten_seconds_before = $moment->minus( second => 10 );

    # create object with the moment '2014-11-01 00:00:00'
    my $moment = Moment->new(dt => '2014-11-27 03:31:23')->get_month_start();

    # create object with the moment '2014-11-30 23:59:59'
    my $moment = Moment->new(dt => '2014-11-27 03:31:23')->get_month_end();

=head1 DESCRIPTION

Features and limitations of this library:

=over

=item * Class represents only UTC time, no timezone info

=item * Object orentied design

=item * Object can't be changed after creation

=item * The precise is one seond

=item * Working with dates in the period from '1800-01-01 00:00:00' to
'2199-12-31 23:59:59'

=item * Dies in case of any errors

=item * No dependencies, but perl

=item * Plays well with Data::Printer

=item * Using SemVer for version numbers

=back

=cut

=head1 new()

Constructor. Creates new Moment object that points to the specified moment
of time. Can be used in 3 different ways:

    my $some_moment = Moment->new(
        # dt format is 'YYYY-MM-DD hh:mm:ss'
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
        # Unix time (a.k.a. POSIX time or Epoch time)
        timestamp => 1000000000,
    );

Dies in case of errors.

=cut

sub new {
    my ($class, @params) = @_;

    if (@params == 0) {
        croak "Incorrect usage. new() must get some params: dt, timestamp or year/month/day/hour/minute/secod. Stopped"
    }

    if (@params % 2 != 0) {
        croak 'Incorrect usage. new() must get hash like: `new( timestamp => 0 )`. Stopped';
    }

    my %params = @params;

    my $self = {};
    bless $self, $class;

    my $input_year = delete $params{year};
    my $input_month = delete $params{month};
    my $input_day = delete $params{day};
    my $input_hour = delete $params{hour};
    my $input_minute = delete $params{minute};
    my $input_second = delete $params{second};

    my $input_dt = delete $params{dt};

    my $input_timestamp = delete $params{timestamp};

    if (%params) {
        croak "Incorrect usage. new() got unknown params: '" . join("', '", (sort keys %params)) . "'. Stopped";
    }

    my $way = 0;

    if (defined($input_timestamp)) {
        $way++;

        if (not $self->_is_int($input_timestamp)) {
            croak "Incorrect usage\. The recieved timestamp is not an integer number. Stopped";
        };

        if ($input_timestamp < -5_364_662_400) {
            croak "Incorrect usage. The recieved timestamp $input_timestamp it too low. It must be >= -5_364_662_400. Stopped";
        };

        if ($input_timestamp > 7_258_118_399) {
            croak "Incorrect usage. The recieved timestamp $input_timestamp it too big. It must be <= 7_258_118_399. Stopped";
        };

        my ($second,$minute,$hour,$day,$month,$year,$wday,$yday,$isdst)
            = gmtime($input_timestamp);

        $self->{_year} = $year + 1900;
        $self->{_month} = $month + 1;
        $self->{_day} = $day;
        $self->{_hour} = $hour;
        $self->{_minute} = $minute;
        $self->{_second} = $second;

        $self->{_timestamp} = $input_timestamp;
        $self->{_dt} = sprintf(
            "%04d-%02d-%02d %02d:%02d:%02d",
            $self->{_year},
            $self->{_month},
            $self->{_day},
            $self->{_hour},
            $self->{_minute},
            $self->{_second},
        );

    }

    if (defined($input_year) or defined($input_month) or defined($input_day)
        or defined($input_hour) or defined($input_minute) or defined($input_second)) {

        $way++;

        if (defined($input_year) and defined($input_month) and defined($input_day)
            and defined($input_hour) and defined($input_minute) and defined($input_second)) {
            # ok
        } else {
            croak "Must specify all params: year, month, day, hour, minute, second. Stopped";
        }

        if ($input_year > 2199) {
            croak "Incorrect usage. Year $input_year it too big. It must be <= 2199. Stopped";
        }

        if ($input_year < 1800) {
            croak "Incorrect usage. Year $input_year it too low. It must be >= 1800. Stopped";
        }

        $self->{_year} = $input_year + 0;
        $self->{_month} = $input_month + 0;
        $self->{_day} = $input_day + 0;
        $self->{_hour} = $input_hour + 0;
        $self->{_minute} = $input_minute + 0;
        $self->{_second} = $input_second + 0;

        $self->{_timestamp} = timegm(
            $self->{_second},
            $self->{_minute},
            $self->{_hour},
            $self->{_day},
            $self->{_month}-1,
            $self->{_year},
        );

        $self->{_dt} = sprintf(
            "%04d-%02d-%02d %02d:%02d:%02d",
            $self->{_year},
            $self->{_month},
            $self->{_day},
            $self->{_hour},
            $self->{_minute},
            $self->{_second},
        );

    }

    if (defined($input_dt)) {
        $way++;

        (
            $self->{_year},
            $self->{_month},
            $self->{_day},
            $self->{_hour},
            $self->{_minute},
            $self->{_second},
        ) = split(/[\s:-]+/, $input_dt);

        if ($self->{_year} > 2199) {
            croak "Incorrect usage. Year $self->{_year} it too big. It must be <= 2199. Stopped";
        }

        if ($self->{_year} < 1800) {
            croak "Incorrect usage. Year $self->{_year} it too low. It must be >= 1800. Stopped";
        }

        $self->{_year} += 0;
        $self->{_month} += 0;
        $self->{_day} += 0;
        $self->{_hour} += 0;
        $self->{_minute} += 0;
        $self->{_second} += 0;

        $self->{_timestamp} = timegm(
            $self->{_second},
            $self->{_minute},
            $self->{_hour},
            $self->{_day},
            $self->{_month}-1,
            $self->{_year},
        );

        $self->{_dt} = $input_dt;

    }

    if ($way == 1) {
        # this is the correct usage of new()
    } else {
        croak "Incorrect usage. new() must get one thing from the list: dt, timestamp or year/month/day/hour/minute/second. Stopped"
    }

    $self->{_weekday_name} = $self->_get_weekday_name($self->{_timestamp});

    return $self;
}

=head1 now()

Constructor. Creates new Moment object that points to the current moment
of time.

    my $current_moment = Moment->now();

=cut

sub now {
    my ($class, @params) = @_;

    if (@params) {
        croak 'Incorrect usage. now() shouldn\'t get any params. Stopped';
    }

    my $self = Moment->new(
        timestamp => time(),
    );

    return $self;
};

=head1 get_timestamp()

Returns the timestamp of the moment stored in the object.

The timestamp is also known as Unix time, POSIX time, Epoch time.

This is the number of seconds passed from '1970-01-01 00:00:00'.

This number can be negative.

    say Moment->new( dt => '1970-01-01 00:00:00' )->get_timestamp(); # 0
    say Moment->new( dt => '2000-01-01 00:00:00' )->get_timestamp(); # 946684800
    say Moment->new( dt => '1960-01-01 00:00:00' )->get_timestamp(); # -315619200

The value that return this method is in the range [-5_364_662_400, 7_258_118_399].

=cut

sub get_timestamp {
    my ($self) = @_;
    return $self->{_timestamp};
}

=head1 get_dt()

Returns the scalar with date and time of the moment stored in the object.
The data in scalar is in format 'YYYY-MM-DD hh:mm:ss'.

    say Moment->now()->get_dt(); # 2014-12-07 11:50:57

=cut

sub get_dt {
    my ($self) = @_;
    return $self->{_dt};
}

=head1 get_year()

Returns the scalar with year of the moment stored in the object.

    say Moment->now()->get_year(); # 2014

The value that return this method is in the range [1800, 2199].

=cut

sub get_year {
    my ($self) = @_;
    return $self->{_year};
}

=head1 get_month()

Returns the scalar with number of month of the moment stored in the object.

    say Moment->now()->get_month(); # 12

Method return '9', not '09'.

=cut

sub get_month {
    my ($self) = @_;
    return $self->{_month};
}

=head1 get_day()

Returns the scalar with number of day since the beginning of mongth of the
moment stored in the object.

    say Moment->now()->get_day(); # 7

Method return '7', not '07'.

=cut

sub get_day {
    my ($self) = @_;
    return $self->{_day};
}

=head1 get_hour()

Returns the scalar with hour of the moment stored in the object.

    say Moment->now()->get_hour(); # 11

Method return '9', not '09'.

=cut

sub get_hour {
    my ($self) = @_;
    return $self->{_hour};
}

=head1 get_minute()

Returns the scalar with minute of the moment stored in the object.

    say Moment->now()->get_hour(); # 50

Method return '9', not '09'.

=cut

sub get_minute {
    my ($self) = @_;
    return $self->{_minute};
}

=head1 get_second()

Returns the scalar with second of the moment stored in the object.

    say Moment->now()->get_second(); # 57

Method return '9', not '09'.

=cut

sub get_second {
    my ($self) = @_;
    return $self->{_second};
}

=head1 get_weekday_name()

Return scalar with the weekday name. Here is the full list of strings that
this method can return: 'monday', 'tuesday', 'wednesday', 'thursday',
'friday', 'saturday', 'sunday'.

    say Moment->now()->get_weekday_name(); # sunday

=cut

sub get_weekday_name {
    my ($self) = @_;

    return $self->{_weekday_name};
}

=head1 is_monday()

Returns true value is the weekday of the moment is monday. Otherwise returns
false value.

=cut

sub is_monday {
    my ($self) = @_;

    return $self->get_weekday_name() eq 'monday';
}

=head1 is_tuesday()

Returns true value is the weekday of the moment is tuesday. Otherwise returns
false value.

=cut

sub is_tuesday {
    my ($self) = @_;

    return $self->get_weekday_name() eq 'tuesday';
}

=head1 is_wednesday()

Returns true value is the weekday of the moment is wednesday. Otherwise returns
false value.

=cut

sub is_wednesday {
    my ($self) = @_;

    return $self->get_weekday_name() eq 'wednesday';
}

=head1 is_thursday()

Returns true value is the weekday of the moment is thursday. Otherwise returns
false value.

=cut

sub is_thursday {
    my ($self) = @_;

    return $self->get_weekday_name() eq 'thursday';
}

=head1 is_friday()

Returns true value is the weekday of the moment is friday. Otherwise returns
false value.

=cut

sub is_friday {
    my ($self) = @_;

    return $self->get_weekday_name() eq 'friday';
}

=head1 is_saturday()

Returns true value is the weekday of the moment is saturday. Otherwise returns
false value.

=cut

sub is_saturday {
    my ($self) = @_;

    return $self->get_weekday_name() eq 'saturday';
}

=head1 is_sunday()

Returns true value is the weekday of the moment is sunday. Otherwise returns
false value.

=cut

sub is_sunday {
    my ($self) = @_;

    return $self->get_weekday_name() eq 'sunday';
}

=head1 is_leap_year()

Returns true value is the year of the moment is leap. Otherwise returns
false value.

=cut

sub is_leap_year {
    my ($self) = @_;

    return '' if $self->get_year() % 4;
    return 1 if $self->get_year() % 100;
    return '' if $self->get_year() % 400;
    return 1;
}

=head1 cmp()

Method to compare 2 object. It works exactly as perl builtin 'cmp' keyword.

    my $result = $moment_1->cmp($moment_2);

It returns -1, 0, or 1 depending on whether the $moment_1 is stringwise less
than, equal to, or greater than the $moment_2

    say Moment->new(dt=>'1970-01-01 00:00:00')->cmp( Moment->new(dt=>'2000-01-01 00:00') ); # -1
    say Moment->new(dt=>'2000-01-01 00:00:00')->cmp( Moment->new(dt=>'2000-01-01 00:00') ); # 0
    say Moment->new(dt=>'2010-01-01 00:00:00')->cmp( Moment->new(dt=>'2000-01-01 00:00') ); # 1

=cut

sub cmp {
    my ($self, @params) = @_;

    if (@params != 1) {
        croak "Incorrect usage. cmp() must get one parameter. Stopped"
    }

    my $moment_2 = $params[0];

    if (blessed($moment_2) and $moment_2->isa('Moment')) {
        return $self->get_timestamp() <=> $moment_2->get_timestamp();
    } else {
        croak "Incorrect usage. cmp() must get Moment object as a parameter. Stopped";
    }

}

=head1 plus()

Method plus() returns new Moment object that differ from the original to the
specified time.

    my $new_moment = $moment->plus(
        day => 1,
        hour => 2,
        minute => 3,
        second => 4,
    );

You can also use negative numbers.

    my $two_hours_ago = $moment->plus( hour => -2 );

Here is an example:

    say Moment->new(dt=>'2010-01-01 00:00:00')
        ->plus( day => 1, hour => 2, minute => 3, second => 4 )
        ->get_dt()
        ;
    # 2010-01-02 02:03:04

=cut

sub plus {
    my ($self, @params) = @_;

    if (@params == 0) {
        croak 'Incorrect usage. plus() must get some params. Stopped';
    }

    if (@params % 2 != 0) {
        croak 'Incorrect usage. plus() must get hash like: `plus( hour => 1 )`. Stopped';
    }

    my %params = @params;

    my $day = $self->_get_value_or_die('plus', 'day', delete($params{day}));
    my $hour = $self->_get_value_or_die('plus', 'hour', delete($params{hour}));
    my $minute = $self->_get_value_or_die('plus', 'minute', delete($params{minute}));
    my $second = $self->_get_value_or_die('plus', 'second', delete($params{second}));

    if (%params) {
        croak "Incorrect usage. plus() got unknown params: '" . join("', '", (sort keys %params)) . "'. Stopped";
    }

    my $new_timestamp = $self->get_timestamp()
        + $day * 86400
        + $hour * 3600
        + $minute * 60
        + $second
        ;

    my $new_moment = Moment->new( timestamp => $new_timestamp );

    return $new_moment;
}

=head1 minus()

Method minus() returns new Moment object that differ from the original to the
specified time.

    my $new_moment = $moment->minus(
        day => 1,
        hour => 2,
        minute => 3,
        second => 4,
    );

You can also use negative numbers.

    my $two_hours_behind = $moment->minus( hour => -2 );

Here is an example:

    say Moment->new(dt=>'2010-01-01 00:00:00')
        ->minus( day => 1, hour => 2, minute => 3, second => 4 )
        ->get_dt()
        ;
    # 2009-12-30 21:56:56

=cut

sub minus {
    my ($self, @params) = @_;

    if (@params == 0) {
        croak 'Incorrect usage. minus() must get some params. Stopped';
    }

    if (@params % 2 != 0) {
        croak 'Incorrect usage. minus() must get hash like: `minus( hour => 1 )`. Stopped';
    }

    my %params = @params;

    my $day = $self->_get_value_or_die('minus', 'day', delete($params{day}));
    my $hour = $self->_get_value_or_die('minus', 'hour', delete($params{hour}));
    my $minute = $self->_get_value_or_die('minus', 'minute', delete($params{minute}));
    my $second = $self->_get_value_or_die('minus', 'second', delete($params{second}));

    if (%params) {
        croak "Incorrect usage. minus() got unknown params: '" . join("', '", (sort keys %params)) . "'. Stopped";
    }

    my $new_timestamp = $self->get_timestamp()
        - $day * 86400
        - $hour * 3600
        - $minute * 60
        - $second
        ;

    my $new_moment = Moment->new( timestamp => $new_timestamp );

    return $new_moment;
}

=head1 get_month_start()

Method get_month_start() returns new Moment object that points to the moment
the month starts.

    # 2014-12-01 00:00:00
    say Moment->new(dt=>'2014-12-07 11:50:57')->get_month_start()->get_dt();

The hour, minute and second of the new object is always 0.

=cut

sub get_month_start {
    my ($self) = @_;

    my $start = Moment->new(
        year => $self->get_year(),
        month => $self->get_month(),
        day => 1,
        hour => 0,
        minute => 0,
        second => 0,
    );

    return $start;
}

=head1 get_month_end()

Method get_month_end() returns new Moment object that points to the moment
the month end.

    # 2014-12-31 23:59:59
    say Moment->new(dt=>'2014-12-07 11:50:57')->get_month_end()->get_dt();

The time of the new object is always '23:59:59'.

=cut

sub get_month_end {
    my ($self) = @_;

    my %days_in_month = (
        1 => 31,
        # no february
        3 => 31,
        4 => 30,
        5 => 31,
        6 => 30,
        7 => 31,
        8 => 31,
        9 => 30,
        10 => 31,
        11 => 30,
        12 => 31,
    );

    my $last_day;

    if ($self->get_month() == 2) {
        if ($self->is_leap_year()) {
            $last_day = 29;
        } else {
            $last_day = 28;
        }
    } else {
        $last_day = $days_in_month{$self->get_month()};
    }

    my $end = Moment->new(
        year => $self->get_year(),
        month => $self->get_month(),
        day => $last_day,
        hour => 23,
        minute => 59,
        second => 59,
    );

    return $end;
}

sub _get_weekday_name {
    my ($self, $timestamp) = @_;

    my %wday2name = (
        0 => 'sunday',
        1 => 'monday',
        2 => 'tuesday',
        3 => 'wednesday',
        4 => 'thursday',
        5 => 'friday',
        6 => 'saturday',
    );

    my ($second,$minute,$hour,$day,$month,$year,$wday,$yday,$isdst)
        = gmtime($timestamp);

    return $wday2name{$wday};
}

# https://metacpan.org/pod/Data::Printer#MAKING-YOUR-CLASSES-DDP-AWARE-WITHOUT-ADDING-ANY-DEPS
sub _data_printer {
    my ($self, $properties) = @_;

    require Term::ANSIColor;

    return Term::ANSIColor::colored($self->get_dt() . ' UTC', 'yellow');
}

sub _is_int {
    my ($self, $maybe_int) = @_;

    return $maybe_int =~ /\A0\Z|\A-?[1-9][0-9]*\Z/;
}

sub _get_value_or_die {
    my ($self, $method_name, $key, $input_value) = @_;

    my $value = $input_value;

    $value = 0 if not defined $value;

    if (not $self->_is_int($value)) {
        croak "Incorrect usage\. $method_name\(\) must get integer for '$key'. Stopped";
    }

    return $value;
}

=head1 SAMPLE USAGE

Find the last day of the current month (for december 2014 it is 31):

    my $day = Moment->now()->get_month_end()->get_day();

Loop for every day in month:

    my $start = Moment->now()->get_month_start();
    my $end = $start->get_month_end();

    my $current = $start;
    while ( $current->cmp($end) == -1 ) {
        say $current->get_day();
        $current = $current->plus( day => 1 );
    }

Find out the weekday name for given date (for 2014-01-01 is is wednesday):

    my $weekday = Moment->new( dt => '2014-01-01 00:00:00' )->get_weekday_name();

Find out how many seconds in one day (the answer is 86400):

    my $moment = Moment->now();
    my $seconds_in_a_day = $moment->get_timestamp() - $moment->minus( day => 1 )->get_timestamp();

=cut

1;
