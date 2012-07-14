package LWP::Protocol::Hosts::https;

use strict;
use warnings;
use parent 'LWP::Protocol::https';
use LWP::Protocol::Hosts;

sub _extra_sock_opts {
    my ($self, $host, $port) = @_;

    my @opts = $self->SUPER::_extra_sock_opts($host, $port);
    if (my $peer_addr = LWP::Protocol::Hosts->registered_peer_addr($host)) {
        push @opts, (PeerAddr => $peer_addr, Host => $host);
    }

    return @opts;
}

sub socket_class { 'LWP::Protocol::https::Socket' }

1;

__END__
