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
1;
