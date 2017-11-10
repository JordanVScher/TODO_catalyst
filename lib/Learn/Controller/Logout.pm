package Learn::Controller::Logout;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=encoding utf8


=head1 NAME

Learn::Controller::Logout - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->logout;

    $c->response->redirect( $c->uri_for('/items') );
}

=encoding utf8

=head1 AUTHOR

Jordan Eokoe,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
