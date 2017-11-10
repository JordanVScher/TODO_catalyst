package Learn::Controller::Items;
use utf8;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=encoding utf8

=head1 NAME

Learn::Controller::Items - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Learn::Controller::Items in Items.');
}

=head2 base

Can place common logic to start chained dispatch here

=cut

sub base : Chained('/') : PathPart('items') : CaptureArgs(0) {
    my ( $self, $c ) = @_;

    # Store the ResultSet in stash so it's available for other methods
    $c->stash( resultset => $c->model('DB::Item') );

    # Print a message to the debug log
    $c->log->debug('*** INSIDE BASE METHOD ***');

    # Load status messages
    $c->load_status_msgs;
}

=head2 object

Pega um item baseado no id e guarda no stash

=cut

sub object : Chained('base') : PathPart('id') : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    #$c->stash->{resultset} = $c->model('DB::Item');

    $c->stash( object => $c->model('DB::Item')->find($id) );
    die "Item $id não encontrado" if !$c->stash->{object};
}

=head2 delete

Deleta um item

=cut

sub delete : Chained('object') : PathPart('delete') : Args(0) {
    my ( $self, $c ) = @_;

    if ( $c->check_user_roles('admin') ) {
        my $id   = $c->stash->{object}->id;
        my $nome = $c->stash->{object}->nome;

        $c->stash->{object}->delete;

        #$c->flash->{status_msg} = "Item $id '$nome' deletado!";

        $c->response->redirect(
            $c->uri_for( $self->action_for('list'), { mid => $c->set_status_msg("Item $id '$nome' deletado!") } ) );

        #$c->forward('list'); <- problema da url
        #$c->response->redirect( $c->uri_for( $self->action_for('list') ) );
        #esse apaga a   $c->stash->{status_msg} = "Item $id deletado!";
    }
    else {
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_status_msg("Você não tem permissão para deletar") }
            )
        );
    }

}

=head2 Encerra

Encerra uma atividade

=cut

sub encerra : Chained('object') : PathPart('encerra') : Args(0) {
    my ( $self, $c ) = @_;

    my $nome = $c->stash->{object}->nome;
    if ( $c->stash->{object}->status ne 'Feito!' ) {
        $c->stash->{object}->update( { status => 'Feito!' } );

        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_status_msg("Atividade $nome finalizada. Bom trabalho!") }
            )
        );

    }
    else {

        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_status_msg("Atividade $nome já foi finalizada.") }
            )
        );

    }

}

=head2 form_create_do

    Coloca items com o FORM

=cut

sub form_create_do : Chained('base') : PathPart('form_create_do') : Args(0) {
    my ( $self, $c ) = @_;

    my $nome   = $c->request->params->{nome} || 'Encerrar essa tarefa!';
    my $data   = localtime();
    my $status = $c->request->params->{status} || 'Fazendo!';

    my $item = $c->model('DB::Item')->create(
        {
            nome   => $nome,
            data   => $data,
            status => $status
        }
    );

    $c->response->redirect(
        $c->uri_for( $self->action_for('list'), { status_msg => "A atividade $nome foi adicionada! Boa sorte ! " } ) );

    #$c->stash( #já era
    #    item     => $item,
    #    template => 'items/create_done.tt2'
    #);

}

=head2 Criar Items URL

  Colocar novo item na lista com o nome usando URL
=cut

sub url_create : Chained('base') : PathPart('url_create') : Args(1) {

    my ( $self, $c, $nome, ) = @_;
    my $data = "2017-11-06T14:43:22";

    # ambos tropeçam no create_done.tt2
    $data = "now()";
    $data = localtime();
    my $status = "Fazendo!";

    my $item = $c->model('DB::Item')->create(
        {
            nome   => $nome,
            data   => $data,
            status => $status
        }
    );
    $c->response->redirect(
        $c->uri_for( $self->action_for('list'), { status_msg => "A atividade $nome foi adicionada! Boa sorte ! " } ) );

    $c->response->header( 'Cache-Control' => 'no-cache' );

}

=head2 list_done

    lista somente as tarefas feitas

sub list_done : Chained('/') : PathPart('items/list_done') : Args(0) {
    my ( $self, $c ) = @_;

    $c->stash( items => [ $c->model('DB::Item')->search( { status => 'Feito!' }, { order_by => ['me.id'] } )->all ] );

    $c->stash( template => 'items/list.tt2' );

}

=cut

=head2 list_falta

    lista somente as tarefas feitas

sub list_falta : Chained('/') : PathPart('items/list_falta') : Args(0) {
    my ( $self, $c ) = @_;

    $c->stash( items => [ $c->model('DB::Item')->search( { status => 'Fazendo!' }, { order_by => ['me.id'] } )->all ] );

    $c->stash( template => 'items/list.tt2' );

}

=cut

=head2 delete_all

Deleta tudo

=cut

sub delete_all : Chained('base') : PathPart('delete_all') : Args(0) {
    my ( $self, $c ) = @_;
    my $result = $c->model('DB::Item');    #isso é resultset!
    if ( $result != 0 ) {
        $result->delete;                   #() <-opcional

        $c->response->redirect( $c->uri_for( $self->action_for('list'), { status_msg => "Tudo foi deletado..." } ) );

    }

    #my @result = $c->model('DB::Item')->search( {}, { order_by => ['me.id'] } )->all; #Isso é result!
    #my $item;
    #foreach my $item (@result) {
    #    $item->delete;
    #}

    #  $c->stash( template => 'items/delete.tt2' );

}

=head2 lista parcial
Lista o que foi feito e o que falta
=cut

sub lista_parcial : Chained('base') : PathPart('lista_parcial') : Args(1) {
    my ( $self, $c, $status ) = @_;

    $c->stash( items => [ $c->model('DB::Item')->lista_feito($status) ] );

    my ( $c1, $c2, $c3 ) = $c->model('DB::Item')->conta_tarefas();

    $c->stash( count1 => $c1, count2 => $c2, count3 => $c3 );

    $c->stash( template => 'items/list.tt2' );

}

=head2 exporta
exporta tarefas para um CSV
=cut

sub exporta : Chained('base') : PathPart('exporta') : Args(0) {
    my ( $self, $c ) = @_;

    use Text::CSV;
    my $row;
    my $csv = Text::CSV->new(
        {
            sep_char     => ',',
            always_quote => 0,
            eol          => "\n",
            quote_space  => 0,

        },

    );

    #open( my $output, '>:encoding(UTF-8)', 'tarefas' . localtime() . '.csv' ) || die "Impossível criar utput.csv";
    open( my $output, '>:encoding(UTF-8)', 'tarefas.csv' ) || die "Impossível criar utput.csv";

    my @result = $c->model('DB::Item')->search( {}, { order_by => ['me.id'] } )->all;

    my @dados = ( "Id", "Nome", "Data", "Status" );
    $row = $csv->combine(@dados);
    $row = $csv->string();

    print $output $row;

    foreach my $item (@result) {

        @dados = ( $item->id, $item->nome, $item->data, $item->status );

        $row = $csv->combine(@dados);
        $row = $csv->string();
        print $output $row;

    }

    $c->response->redirect(
        $c->uri_for( $self->action_for('list'), { mid => $c->set_status_msg("Exportado para CSV com sucesso :)") } ) );
}

=head1 AUTHOR
Jordan Eokoe,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

=head2 list
Fetch items in stash to be displayed
=cut

sub list : Chained('base') : PathPart('list') : Args(0) {
    my ( $self, $c ) = @_;

    #  $c->stash( items => [ $c->model('DB::Item')->search( {}, { order_by => { '-desc' => ['me.id'] } } )->all ] );
    #$c->stash( items => [ $c->model('DB::Item')->search( {}, { order_by => ['me.id'] } )->all ] );
    my ( $c1, $c2, $c3 ) = $c->model('DB::Item')->conta_tarefas();
    $c->stash( items => [ $c->model('DB::Item')->search( {}, { order_by => ['me.id'] } )->all ] );
    $c->stash( count1 => $c1, count2 => $c2, count3 => $c3 );
    $c->stash( template => 'items/list.tt2' );

    # essa linha abaixo pode ser comentada
    #  $c->stash( template => 'items/list.tt2' );
}

=head2 auto

Verifica se tem usuário,se não, envia pra login

=cut

# Note that 'auto' runs after 'begin' but before your actions and that
# 'auto's "chain" (all from application path to most specific class are run)
# See the 'Actions' section of 'Catalyst::Manual::Intro' for more info.
sub auto : Private {
    my ( $self, $c ) = @_;

    if ( $c->controller eq $c->controller('Login') ) {
        return 1;
    }

    if ( !$c->user_exists ) {
        $c->log->debug('Usuário não existe');
        $c->response->redirect( $c->uri_for('/login') );

        return 0;
    }

    return 1;
}

=head2 contador

Não tem nada a ver com chained
=cut

__PACKAGE__->meta->make_immutable;

1;
