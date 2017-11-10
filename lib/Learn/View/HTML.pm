package Learn::View::HTML;
use Learn;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(

    # Change default TT extension
    TEMPLATE_EXTENSION => '.tt2',

    # Set the location for TT files
    INCLUDE_PATH => [ Learn->path_to( 'root', 'src' ), ],

    # Set to 1 for detailed timer stats in your HTML as comments
    TIMER => 0,

    # This is your wrapper template located in the 'root/src'
    WRAPPER => 'wrapper.tt2',

    ENCODING => 'utf-8',
);

=head1 NAME

Learn::View::HTML - TT View for Learn

=head1 DESCRIPTION

TT View for Learn.

=head1 SEE ALSO

L<Learn>

=head1 AUTHOR

Jordan Eokoe,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
