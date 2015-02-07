use strict;
use warnings;
use Test::More;

BEGIN: {
unless (use_ok('WWW-Saucelabs')) {
BAIL_OUT("Couldn't load WWW-Saucelabs");
exit;
}
}



done_testing;
