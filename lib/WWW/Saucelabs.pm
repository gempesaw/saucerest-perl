use strict;
use warnings;
package WWW::Saucelabs;

# ABSTRACT: A perl client to the Saucelabs REST API (WIP)
use Net::HTTP::Knork;
use Carp qw/croak/;
use JSON qw/to_json/;
use Moo;
use namespace::clean;

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

=attr user

REQUIRED: pass in your Saucelabs user. Alternatively, you can
export it to the environment variable SAUCE_USER in place of
specifying it during construction.

If there's no SAUCE_USER environment variable, and you neglect to
specify the user during construciton, we will croak.

=cut

has user => (
    is => 'ro',
    default => sub {
        if (exists $ENV{SAUCE_USER} && $ENV{SAUCE_USER}) {
            return $ENV{SAUCE_USER};
        }
        else {
            croak 'You must specify a user, or set the environment variable SAUCE_USER';
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
            required_params => [ 'job_id' ],
            path => '/:user/jobs/:job_id/assets',
        },
        get_job_status => {
            method => 'GET',
            required_params => [ 'job_id' ],
            path => '/:user/jobs/job_id'
        },
        get_jobs => {
            method => 'GET',
            optional_params => [ 'limit' ],
            path => '/:user/jobs',
        },
        get_sauce_status => {
            method => 'GET',
            base_url => 'http://saucelabs.com/rest/v1',
            path => '/info/status',
        },
        set_job_status => {
            method => 'PUT',
            required_params => [ 'job_id', 'status' ],
            path => '/:user/jobs/:job_id'
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

1;
