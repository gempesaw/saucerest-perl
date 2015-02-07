use strict;
use warnings;
use Test::More;
use Test::Fatal;


BEGIN: {
    unless (use_ok('WWW::Saucelabs')) {
        BAIL_OUT("Couldn't load WWW-Saucelabs");
        exit;
    }
}

AUTHENTICATION: {
    my %reset_env = %ENV;

    %ENV = %reset_env;
    $ENV{SAUCE_ACCESS_KEY} = 'fake-access-key';
    like(exception { WWW::Saucelabs->new }, qr/SAUCE_USER/, 'we throw about missing a user');

    %ENV = %reset_env;
    $ENV{SAUCE_USER} = 'fake-sauce-user';
    like(exception { WWW::Saucelabs->new }, qr/SAUCE_ACCESS_KEY/, 'we throw about missing an access key');

    %ENV = %reset_env;
    $ENV{SAUCE_USER} = 'fake-sauce-user';
    $ENV{SAUCE_ACCESS_KEY} = 'fake-access-key';
    my $env_client;
    is(exception { $env_client = WWW::Saucelabs->new }, undef, 'can get setup solely from env vars');
    is($env_client->username, 'fake-sauce-user', 'constructor overrides env username');
    is($env_client->access_key, 'fake-access-key', 'constructor overrides env access key');

    %ENV = %reset_env;
    my $client;
    is(exception {
        $client = WWW::Saucelabs->new(
            username => 'username',
            access_key => 'access-key'
        );
    },
       undef,
       'can get set up solely from instantiation');
    is($client->username, 'username', 'constructor overrides env username');
    is($client->access_key, 'access-key', 'constructor overrides env access key');
}


done_testing;
