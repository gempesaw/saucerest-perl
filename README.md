# NAME

WWW::Saucelabs - An incomplete, wip perl client to the Saucelabs REST API

[![Build Status](https://travis-ci.org/gempesaw/saucerest-perl.svg?branch=master)](https://travis-ci.org/gempesaw/saucerest-perl)

# VERSION

version 0.0201

# SYNOPSIS

    my $sauce = WWW::Saucelabs->new;

    my $jobs = $sauce->get_jobs({limit => 5 });
    map { say $_->{id} } @$jobs;

# DESCRIPTION

This module is an incomplete perl client for the [Saucelabs REST
API](https://docs.saucelabs.com/reference/rest-api/). Saucelabs
provides webdriver instances for automated testing in the cloud for
CI.

This module is perilously incomplete and we'd love for you to
contribute. (We have no affiliation with Saucelabs other than we love
using their services :D)

# ATTRIBUTES

## user

REQUIRED: pass in your Saucelabs user. Alternatively, you can
export it to the environment variable SAUCE\_USERNAME in place of
specifying it during construction.

If there's no SAUCE\_USERNAME environment variable, and you neglect to
specify the user during construciton, we will croak.

## access\_key

REQUIRED: pass in your Saucelabs access key. Alternatively, you can
export it to the environment variable SAUCE\_ACCESS\_KEY in place of
specifying it during construction.

If there's no SAUCE\_ACCESS\_KEY environment variable, and you neglect to
specify the access\_key during construciton, we will croak.

# METHODS

## fail\_job( $job\_id )

Shortcut to set the status of a job to failure. `$job_id` should be a
string.

## pass\_job( $job\_id )

Shortcut to set the status of a job to success. `$job_id` should be a
string.

# IMPLEMENTED ENDPOINTS

## get\_job\_assets({ job\_id => $job\_id })

Retrieve the assets for a given job id.

## get\_job\_status({ job\_id => $job\_id })

Retrieve the status of a given job by its job\_id.

## get\_jobs

Retrieve a list of available jobs

## set\_job\_status({ job\_id => $job\_id, status => JSON::true|JSON::false })

Set the status of a given job to success or failure.

## get\_sauce\_status

Get the current status of the Saucelabs service.

# BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/gempesaw/saucerest-perl/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

# AUTHOR

Daniel Gempesaw <gempesaw@gmail.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Daniel Gempesaw.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
