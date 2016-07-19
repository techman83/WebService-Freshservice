package WebService::Freshservice::Request;

use v5.010;
use strict;
use warnings;
use Method::Signatures 20140224;
use Moo;
use namespace::autoclean;

# ABSTRACT: LWP Wrapper for hacking basic auth

# VERSION: Generated by DZP::OurPkg:Version

=head1 SYNOPSIS

  use WebService::Freshservice::Request;

  my $request = WebService::Freshservice::Request->new( apikey => 'xxxxxxxxxxxxxxxxxxxxxx' );

=head1 DESCRIPTION

Provides a light wrapper to LWP::UserAgent to provide basic auth.

=cut

use base 'LWP::UserAgent';

has 'apikey'  => ( is => 'ro', required => 1 );

method get_basic_credentials(...) {
  return $self->apikey, "X";
}

1;