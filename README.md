# NAME

WWW::Saucelabs - A perl client to the Saucelabs REST API (WIP)

# VERSION

version 0.01

# SYNOPSIS

# DESCRIPTION

# ATTRIBUTES

## username

REQUIRED: pass in your Saucelabs username. Alternatively, you can
export it to the environment variable SAUCE\_USER in place of
specifying it during construction.

If there's no SAUCE\_USER environment variable, and you neglect to
specify the username during construciton, we will croak.

## access\_key

REQUIRED: pass in your Saucelabs access key. Alternatively, you can
export it to the environment variable SAUCE\_ACCESS\_KEY in place of
specifying it during construction.

If there's no SAUCE\_ACCESS\_KEY environment variable, and you neglect to
specify the username during construciton, we will croak.

## trace

OPTIONAL: Set trace to 1 or 2 to see debugging output. Defaults to 0.

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
