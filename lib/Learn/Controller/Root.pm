package Learn::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config( namespace => '' );

=encoding utf-8

=head1 NAME

Learn::Controller::Root - Root Controller for Learn

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->stash( template => 'root.tt2' );

}

=head2 json

Mostra um json de exemplo
=cut

sub json : Chained('/') : PathPart('json') : Args(0) {
    my ( $self, $c ) = @_;

    use JSON::MaybeXS;
    use File::Slurp;
    use Data::Dumper::Perltidy;

    my $filename    = "exemplo.json";
    my $text        = read_file($filename);
    my $json_output = decode_json($text);

    my $filename2    = "teste.json";
    my $text2        = read_file($filename2);
    my $json_output2 = decode_json($text2);

    $c->stash( texto  => Dumper($json_output) );
    $c->stash( texto2 => Dumper($json_output2) );

    $c->stash( template => 'json.tt2' );

    #  $c->response->body( Dumper($json_output) );

}

=head2 default

Standard 404 error page

=cut

sub default : Path {
    my ( $self, $c ) = @_;
    $c->response->body('Page not found');
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') { }

=head1 AUTHOR

Jordan Eokoe,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
