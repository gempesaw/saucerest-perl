use strict;
use warnings;

use Test::LWP::UserAgent;
use Test::Fatal;
use Test::More;

BEGIN: {
    unless (use_ok('WWW::Saucelabs')) {
        BAIL_OUT("Couldn't load WWW-Saucelabs");
        exit;
    }
}

CLIENT: {
    my $tua = Test::LWP::UserAgent->new;
    my $return_endpoint = sub {
        my ($req) = @_;
        my $res = Net::HTTP::Knork::Response->new('200','OK');
        $res->request( $req );
        return $res;
    };

    $tua->map_response(1, $return_endpoint);

    my $c = WWW::Saucelabs->new(
        user => 'user',
        access_key => 'access-key',
        _ua => $tua
    );
    ok($c->_client->isa('Net::HTTP::Knork'), 'we can build a knork');

    my $methods = $c->_spec->{methods};
    foreach (keys %$methods) {
        ok($c->can($_), 'all spec methods are properly handled by the client');
    }

    my $no_auth_endpoints = {
        get_sauce_status => 'http://saucelabs.com/rest/v1/info/status'
    };

    foreach (keys %$no_auth_endpoints) {
        my $res = $c->$_;
        my $endpoint = $res->request->uri->as_string;;
        my $expected = $no_auth_endpoints->{$_};

        ok($endpoint eq $expected, $_ . ' hits ' . $expected . ' as expected');
    }
}

BASE_URL: {
    my $c = WWW::Saucelabs->new(
        user => 'user',
        access_key => 'access'
    );

    my $expected_url = 'https://user:access@saucelabs.com/rest/v1';
    is($c->_base_url, $expected_url, 'we construct the base url correctly');
    is($c->_spec->{base_url}, $expected_url, 'and put it on the spec');
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
    is($env_client->user, 'fake-sauce-user', 'constructor overrides env user');
    is($env_client->access_key, 'fake-access-key', 'constructor overrides env access key');

    %ENV = %reset_env;
    my $client;
    is(exception {
        $client = WWW::Saucelabs->new(
            user => 'user',
            access_key => 'access-key'
        );
    },
       undef,
       'can get set up solely from instantiation');
    is($client->user, 'user', 'constructor overrides env user');
    is($client->access_key, 'access-key', 'constructor overrides env access key');
}

done_testing;
