package Learn::Schema::ResultSet::Item;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

=head2 lista_feito
Lista items feitos
=cut

sub lista_feito {
    my ( $self, $status ) = @_;

    return $self->search(
        {
            status => $status
        }
    );
}

=head2 conta_tarefas
Conta tarefas
=cut

sub conta_tarefas {
    my ($self) = @_;

    return ( $self->count, $self->lista_feito('Fazendo!')->count, $self->lista_feito('Feito!')->count );
}

1;
