use strict;
use warnings;
package WWW::Saucelabs;

# ABSTRACT: An incomplete, wip perl client to the Saucelabs REST API
use Net::HTTP::Knork;
use Carp qw/croak/;
use JSON qw/to_json/;
use Moo;
use namespace::clean;

=for markdown [![Build Status](https://travis-ci.org/gempesaw/saucerest-perl.svg?branch=master)](https://travis-ci.org/gempesaw/saucerest-perl)

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

=attr user

REQUIRED: pass in your Saucelabs user. Alternatively, you can
export it to the environment variable SAUCE_USERNAME in place of
specifying it during construction.

If there's no SAUCE_USERNAME environment variable, and you neglect to
specify the user during construciton, we will croak.

=cut

has user => (
    is => 'ro',
    default => sub {
        if (exists $ENV{SAUCE_USERNAME} && $ENV{SAUCE_USERNAME}) {
            return $ENV{SAUCE_USERNAME};
        }
        else {
            croak 'You must specify a user, or set the environment variable SAUCE_USERNAME';
        }
    }
);

=attr access_key

REQUIRED: pass in your Saucelabs access key. Alternatively, you can
export it to the environment variable SAUCE_ACCESS_KEY in place of
specifying it during construction.

If there's no SAUCE_ACCESS_KEY environment variable, and you neglect to
specify the access_key during construciton, we will croak.

=cut

has access_key => (
    is => 'ro',
    default => sub {
        if (exists $ENV{SAUCE_ACCESS_KEY} && $ENV{SAUCE_ACCESS_KEY}) {
            return $ENV{SAUCE_ACCESS_KEY};
        }
        else {
            croak 'You must specify an access_key, or set the environment variable SAUCE_ACCESS_KEY';
        }
    }
);

my $spec = {
    name => 'Saucelabs REST API',
    formats => [ 'json' ],
    version => '0.1',
    methods => {
        get_job_assets => {
            method => 'GET',
            required_params => [ 'user', 'job_id' ],
            path => '/:user/jobs/:job_id/assets',
        },
        get_job_status => {
            method => 'GET',
            required_params => [ 'user', 'job_id' ],
            path => '/:user/jobs/job_id'
        },
        get_jobs => {
            method => 'GET',
            required_params => [ 'user' ],
            optional_params => [ 'limit' ],
            path => '/:user/jobs',
        },
        set_job_status => {
            method => 'PUT',
            required_params => [ 'user', 'job_id' ],
            path => '/:user/jobs/:job_id'
        },
        get_sauce_status => {
            method => 'GET',
            base_url => 'http://saucelabs.com/rest/v1',
            path => '/info/status',
        },
    }
};

has _base_url => (
    is => 'ro',
    init_arg => undef,
    lazy => 1,
    builder => sub {
        my ($self) = @_;

        my $base_url = 'https://' . $self->user . ':' . $self->access_key;
        $base_url .= '@saucelabs.com/rest/v1';

        return $base_url;
    }
);

has _spec => (
    is => 'ro',
    init_arg => undef,
    lazy => 1,
    default => sub {
        my ($self) = @_;
        $spec->{base_url} = $self->_base_url;
        return $spec;
    }
);

has _client => (
  is => 'ro',
  lazy => 1,
  handles => [ keys %{ $spec->{methods} } ],
  builder => sub {
      my ($self) = @_;

      my $knork = Net::HTTP::Knork->new(
          spec => to_json($self->_spec),
          client => $self->_ua,
          default_params => {
              user => $self->user
          }
      );

      return $knork;
  }
);

has _ua => (
    is => 'ro',
    default => sub { LWP::UserAgent->new }
);

=method fail_job( $job_id )

Shortcut to set the status of a job to failure. C<$job_id> should be a
string.

=cut

sub fail_job {
    my ($self, $job) = @_;
    croak 'We need a job to fail' unless $job;

    $self->set_job_status({
        job_id => $job,
        payload => {
            status => JSON::false
        }
    });
}

=method pass_job( $job_id )

Shortcut to set the status of a job to success. C<$job_id> should be a
string.

=cut

sub pass_job {
    my ($self, $job) = @_;
    croak 'We need a job to pass' unless $job;

    $self->set_job_status({
        job_id => $job,
        payload => {
            status => JSON::true
        }
    }
    );
}

1;
