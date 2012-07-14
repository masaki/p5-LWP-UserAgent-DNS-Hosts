use strict;
use Test::More;
use Test::Fake::HTTPD;
use LWP::UserAgent;
use LWP::Simple;
use LWP::Protocol::Hosts;

{
    my $httpd = run_http_server {
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

    my $uri = sprintf 'http://www.google.com:%s/search?q=foobar' => $httpd->port;

    my $ua = LWP::UserAgent->new;
    my $res = $ua->get($uri);
    is $res->content => '/search?q=foobar';
    is $res->header('X-FooBar') => 'foobar';

    my $body = get $uri;
    is $body => '/search?q=foobar';
}

done_testing;
