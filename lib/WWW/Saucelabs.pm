use strict;
use warnings;
package WWW::Saucelabs;

# ABSTRACT: A perl client to the Saucelabs REST API (WIP)
use Carp qw/croak/;
use JSON qw/to_json/;
use Moo;
use namespace::clean;

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

=attr username

REQUIRED: pass in your Saucelabs username. Alternatively, you can
export it to the environment variable SAUCE_USER in place of
specifying it during construction.

If there's no SAUCE_USER environment variable, and you neglect to
specify the username during construciton, we will croak.

=cut

has username => (
    is => 'ro',
    default => sub {
        if (exists $ENV{SAUCE_USER} && $ENV{SAUCE_USER}) {
            return $ENV{SAUCE_USER};
        }
        else {
            croak 'You must specify a username, or set the environment variable SAUCE_USER';
        }
    }
);

=attr access_key

REQUIRED: pass in your Saucelabs access key. Alternatively, you can
export it to the environment variable SAUCE_ACCESS_KEY in place of
specifying it during construction.

If there's no SAUCE_ACCESS_KEY environment variable, and you neglect to
specify the username during construciton, we will croak.

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
            required_params => [ 'username', 'job_id' ],
            path => '/:username/jobs/:job_id/assets',
        },
        get_job_status => {
            method => 'GET',
            required_params => [ 'username', 'job_id' ],
            path => '/:username/jobs/job_id'
        },
        get_jobs => {
            method => 'GET',
            required_params => [ 'username' ],
            optional_params => [ 'limit'    ],
            path => '/:username/jobs',
        },
        get_sauce_status => {
            method => 'GET',
            required_params => [ 'username' ],
            path => '/info/status',
        },
        set_job_status => {
            method => 'PUT',
            required_params => [ 'username', 'job_id', 'status' ],
            path => '/:username/jobs/:job_id'
        },
    }
};

has _base_url => (
    is => 'ro',
    init_arg => undef,
    lazy => 1,
    builder => sub {
        my ($self) = @_;

        my $base_url = 'https://' . $self->username . ':' . $self->access_key;
        $base_url .= '@saucelabs.com/rest/v1';

        return $base_url;
    }
);

1;
