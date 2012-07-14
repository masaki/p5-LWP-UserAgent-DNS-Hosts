package LWP::Protocol::Hosts;

use 5.008001;
use strict;
use warnings;
use Carp;
use LWP::Protocol;
use Guard;

our $VERSION = '0.01';
$VERSION = eval $VERSION;

our @Protocols = qw(http https);
our %Implementors;

our %Hosts;

sub register_host {
    my ($class, $host, $peer_addr) = @_;
    $Hosts{$host} = $peer_addr;
}

sub registered_peer_addr {
    my ($class, $host) = @_;
    return $Hosts{$host};
}

sub _implementor {
    my ($class, $proto) = @_;
    return join '::' => $class, $proto;
}

sub enable_override {
    my $class = shift;

    for my $proto (@Protocols) {
        if (my $orig = LWP::Protocol::implementor($proto)) {
            my $impl = $class->_implementor($proto);
            if (eval "require $impl; 1") {
                LWP::Protocol::implementor($proto => $impl);
                $Implementors{$proto} = $orig;
            }
        }
        else {
            carp("LWP::Protocol::$proto is unavailable. Skip overriding it.");
        }
    }

    if (defined wantarray) {
        return guard { $class->disable_override };
    }
}

sub disable_override {
    my $class = shift;
    for my $proto (@Protocols) {
        if (my $impl = $Implementors{$proto}) {
            LWP::Protocol::implementor($proto, $impl);
        }
    }
}

1;

=encoding utf-8

=for stopwords

=head1 NAME

LWP::Protocol::Hosts - Override LWP HTTP/HTTPS request's host like /etc/hosts

=head1 SYNOPSIS

  use LWP::UserAgent;
  use LWP::Protocol::Hosts;

  LWP::Protocol::Hosts->register_host(
      'www.cpan.org' => '127.0.0.1',
  );

  LWP::Protocol::Hosts->enable_override;

  # override request hosts with peer addr defined above
  my $ua  = LWP::UserAgent->new;
  my $res = $ua->get("http://www.cpan.org/");
  print $res->content; # is same as "http://127.0.0.1/" content

=head1 DESCRIPTION

LWP::Protocol::Hosts is a module to override HTTP/HTTPS request
peer addresses that uses LWP::UserAgent.

=head1 METHODS

=over 4

=item register_host($host, $peer_addr)

  LWP::Protocol::Hosts->register_host($host, $peer_addr);

Registers a pair of hostname and peer ip address.

  # /etc/hosts
  127.0.0.1    example.com

equals to:

  LWP::Protocol::Hosts->regiter_hosts('example.com', '127.0.0.1');

=item enable_override

  LWP::Protocol::Hosts->enable_override;
  my $guard = LWP::Protocol::Hosts->enable_override;

Enables to override hook.

If called in a non-void context, returns a L<Guard> object that
automatically resets the override when it goes out of context.

=item disable_override

  LWP::Protocol::Hosts->disable_override;

Disables to override hook.

If you use the guard interface described above,
it will be automatically called for you.

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<LWP::Protocol>, L<LWP::Protocol::http>, L<LWP::Protocol::https>

=cut
