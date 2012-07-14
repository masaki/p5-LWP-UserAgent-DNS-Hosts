package LWP::Protocol::Hosts;

use 5.008001;
use strict;
use warnings;

our $VERSION = '0.01';
$VERSION = eval $VERSION;

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

  LWP::Protocol::Hosts->override;

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

=item override

  LWP::Protocol::Hosts->override;
  my $guard = LWP::Protocol::Hosts->override;

Enables to override hook.

If called in a non-void context, returns a L<Guard> object that
automatically resets the override when it goes out of context.

=item unoverride

  LWP::Protocol::Hosts->unoverride;

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
