use strict;
use warnings;

use Test::LWP::UserAgent;
use Test::Fatal;
use Test::Spec;

BEGIN: {
    unless (use_ok('WWW::Saucelabs')) {
        BAIL_OUT("Couldn't load WWW-Saucelabs");
        exit;
    }
}

describe 'Saucelabs' => sub {
    my $c;

    before each => sub {
        $c = WWW::Saucelabs->new(
            user => 'user',
            access_key => 'access'
        );
    };

    describe 'client' => sub {
        it 'should be a knork' => sub {
            ok($c->_client->isa('Net::HTTP::Knork'));
        };
    };

    describe 'spec methods' => sub {
        they 'should all be handled' => sub {
            my $methods = $c->_spec->{methods};
            my @missing = ();

            foreach my $method_name (keys %$methods) {
                unless ($c->can($method_name)) {
                    push @missing, 'missing ' . $method_name . "\n"
                }
            }

            print @missing if @missing;
            is(scalar @missing, 0);
        }
    };

    describe 'endpoints' => sub {
        my ($mock_client, $tua, $return_endpoint);
        before each => sub {
            $tua = Test::LWP::UserAgent->new;
            $return_endpoint = sub {
                my ($req) = @_;
                my $res = Net::HTTP::Knork::Response->new('200','OK');
                $res->request( $req );
                return $res;
            };
            $tua->map_response(1, $return_endpoint);

            $mock_client = WWW::Saucelabs->new(
                user => 'name',
                access_key => 'access',
                _ua => $tua
            );
        };

        describe 'without auth' => sub {
            my $no_auth_endpoints = {
                get_sauce_status => 'http://saucelabs.com/rest/v1/info/status'
            };

            describe 'should use the correct endpoint:' => sub {
                foreach my $method_name (keys %$no_auth_endpoints) {
                    it $method_name => sub {
                        my $res = $mock_client->$method_name;
                        my $endpoint = $res->request->uri->as_string;;
                        my $expected = $no_auth_endpoints->{$method_name};

                        ok($endpoint eq $expected);
                    }
                }
            };
        };
    };

    describe 'base url' => sub {
        my $expected_url = 'https://user:access@saucelabs.com/rest/v1';

        it 'should be properly constructed' => sub {
            is($c->_base_url, $expected_url);
        };
        it 'should be on the spec' => sub {
            is($c->_spec->{base_url}, $expected_url);
        };
    };
};

describe 'Authentication' => sub {
    my %pristine_env = %ENV;
    my %reset_env = %pristine_env;

    delete $reset_env{SAUCE_USER};
    delete $reset_env{SAUCE_ACCESS_KEY};

    before each => sub { %ENV = %reset_env; };
    after all => sub { %ENV = %pristine_env; };

    describe failure => sub {
        it 'should throw without a user' => sub {
            $ENV{SAUCE_ACCESS_KEY} = 'fake-access-key';
            like(exception { WWW::Saucelabs->new }, qr/SAUCE_USER/);
        };

        it 'should throw without an access key' => sub {
            $ENV{SAUCE_USER} = 'fake-sauce-user';
            like(exception { WWW::Saucelabs->new }, qr/SAUCE_ACCESS_KEY/);
        };
    };

    describe 'success' => sub {
        my ($env_client, $user, $access);
        $user = 'env-user';
        $access = 'env-access';

        before each => sub {
            $ENV{SAUCE_USER} = $user;
            $ENV{SAUCE_ACCESS_KEY} = $access;
        };

        it 'should be able to find everything in env vars' => sub {
            is(exception { $env_client = WWW::Saucelabs->new }, undef);
        };

        it 'should override env vars with constructor opts' => sub {
            $env_client = WWW::Saucelabs->new(
                user => 'user',
                access_key => 'access_key'
            );
            is($env_client->user, 'user');
            is($env_client->access_key, 'access_key');
        };
    };
};

runtests;
