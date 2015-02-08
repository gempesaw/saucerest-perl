# NAME

WWW::Saucelabs - An incomplete, wip perl client to the Saucelabs REST API

[![Build Status](https://travis-ci.org/gempesaw/saucerest-perl.svg?branch=master)](https://travis-ci.org/gempesaw/saucerest-perl)

# VERSION

version 0.01

# SYNOPSIS

# DESCRIPTION

# ATTRIBUTES

## user

REQUIRED: pass in your Saucelabs user. Alternatively, you can
export it to the environment variable SAUCE\_USER in place of
specifying it during construction.

If there's no SAUCE\_USER environment variable, and you neglect to
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
