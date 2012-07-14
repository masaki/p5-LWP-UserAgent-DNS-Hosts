use strict;
use Test::More;
use Test::Fake::HTTPD;
use LWP::UserAgent;
use LWP::Protocol::Hosts;

plan skip_all => 'LWP::Protocol::https required'
    unless eval 'use LWP::Protocol::https; 1';
plan skip_all => 'HTTP::Daemon::SSL required'
    unless eval 'use HTTP::Daemon::SSL; 1';

{
    my $httpd = run_https_server {
        my $req = shift;
        return [
            200,
            [
                'Content-Type' => 'text/plain',
                'X-FooBar'     => 'foobar',
            ],
            [ $req->uri ],
        ];
    };

    LWP::Protocol::Hosts->register_host('www.google.com' => '127.0.0.1');
    my $guard = LWP::Protocol::Hosts->enable_override;

    my $uri = sprintf 'https://www.google.com:%s/search?q=foobar' => $httpd->port;

    my $ua = LWP::UserAgent->new(
        ssl_opts => { SSL_verify_mode => 0, verify_hostname => 0 },
    );
    my $res = $ua->get($uri);
    is $res->content => '/search?q=foobar';
    is $res->header('X-FooBar') => 'foobar';
}

done_testing;
