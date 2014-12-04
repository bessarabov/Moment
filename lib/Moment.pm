package Moment;

# ABSTRACT: working with UTC based time

use strict;
use warnings FATAL => 'all';

use Carp;
use Time::Local;
use Time::Piece;

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

=item * Plays well with Data::Printer

=item * Using SemVer for version numbers

=back

=cut

=head1 new()

=cut

sub new {
    my ($class, %params) = @_;

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
        croak "Got unknown params: ", join (keys %params) . ".";
    }

    my $way = 0;

    if (defined($input_timestamp)) {
        $way++;

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
            croak "Must specify all params: year, month, day, hour, minute, second";
        }

        $self->{_year} = $input_year;
        $self->{_month} = $input_month;
        $self->{_day} = $input_day;
        $self->{_hour} = $input_hour;
        $self->{_minute} = $input_minute;
        $self->{_second} = $input_second;

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

    if ($way != 1) {
        croak "Incorrect usage";
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
    my ($class, %params) = @_;

    if (%params) {
        croak "Got unknown params: ", join (keys %params) . ".";
    }

    my $self = Moment->new(
        timestamp => time(),
    );

    return $self;
};

=head1 get_timestamp

=cut

sub get_timestamp {
    my ($self) = @_;
    return $self->{_timestamp};
}

=head1 get_dt

=cut

sub get_dt {
    my ($self) = @_;
    return $self->{_dt};
}

=head1 get_year

=cut

sub get_year {
    my ($self) = @_;
    return $self->{_year};
}

=head1 get_month

=cut

sub get_month {
    my ($self) = @_;
    return $self->{_month};
}

=head1 get_day

=cut

sub get_day {
    my ($self) = @_;
    return $self->{_day};
}

=head1 get_hour

=cut

sub get_hour {
    my ($self) = @_;
    return $self->{_hour};
}

=head1 get_minute

=cut

sub get_minute {
    my ($self) = @_;
    return $self->{_minute};
}

=head1 get_second

=cut

sub get_second {
    my ($self) = @_;
    return $self->{_second};
}

=head1 get_weekday_name

=cut

sub get_weekday_name {
    my ($self) = @_;

    return $self->{_weekday_name};
}

=head1 is_monday

=cut

sub is_monday {
    my ($self) = @_;

    return $self->get_weekday_name() eq 'monday';
}

=head1 is_tuesday

=cut

sub is_tuesday {
    my ($self) = @_;

    return $self->get_weekday_name() eq 'tuesday';
}

=head1 is_wednesday

=cut

sub is_wednesday {
    my ($self) = @_;

    return $self->get_weekday_name() eq 'wednesday';
}

=head1 is_thursday

=cut

sub is_thursday {
    my ($self) = @_;

    return $self->get_weekday_name() eq 'thursday';
}

=head1 is_friday

=cut

sub is_friday {
    my ($self) = @_;

    return $self->get_weekday_name() eq 'friday';
}

=head1 is_saturday

=cut

sub is_saturday {
    my ($self) = @_;

    return $self->get_weekday_name() eq 'saturday';
}

=head1 is_sunday

=cut

sub is_sunday {
    my ($self) = @_;

    return $self->get_weekday_name() eq 'sunday';
}

=head1 cmp

=cut

sub cmp {
    my ($self, $moment_2) = @_;

    return $self->get_timestamp() <=> $moment_2->get_timestamp();
}

=head1 plus

=cut

sub plus {
    my ($self, %params) = @_;

    my $day = delete $params{day};
    $day = 0 if not defined $day;
    my $hour = delete $params{hour};
    $hour = 0 if not defined $hour;
    my $minute = delete $params{minute};
    $minute = 0 if not defined $minute;
    my $second = delete $params{second};
    $second = 0 if not defined $second;

    if (%params) {
        croak "Got unknown params: ", join (keys %params) . ".";
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

=head1 minus

=cut

sub minus {
    my ($self, %params) = @_;

    my $day = delete $params{day};
    $day = 0 if not defined $day;
    my $hour = delete $params{hour};
    $hour = 0 if not defined $hour;
    my $minute = delete $params{minute};
    $minute = 0 if not defined $minute;
    my $second = delete $params{second};
    $second = 0 if not defined $second;

    if (%params) {
        croak "Got unknown params: ", join (keys %params) . ".";
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

=head1 get_month_start

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

=head1 get_month_end

=cut

sub get_month_end {
    my ($self) = @_;

    my $last_day = Time::Piece->strptime(
        $self->get_month() . $self->get_year(),
        "%m%Y",
    )->month_last_day();

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

    return Term::ANSIColor::colored($self->get_dt() . ' UTC', 'bright_green');
}

1;
