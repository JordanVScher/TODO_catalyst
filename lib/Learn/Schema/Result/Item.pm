use utf8;
package Learn::Schema::Result::Item;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Learn::Schema::Result::Item

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::EncodedColumn>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components(
  "InflateColumn::DateTime",
  "TimeStamp",
  "EncodedColumn",
  "PassphraseColumn",
);

=head1 TABLE: C<items>

=cut

__PACKAGE__->table("items");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'items_id_seq'

=head2 nome

  data_type: 'text'
  is_nullable: 1

=head2 data

  data_type: 'timestamp'
  is_nullable: 1

=head2 status

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "items_id_seq",
  },
  "nome",
  { data_type => "text", is_nullable => 1 },
  "data",
  { data_type => "timestamp", is_nullable => 1 },
  "status",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07047 @ 2017-11-08 16:39:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zXJQspmBeAcATpCEa0y9VA

# You can replace this text with custom code or comments, and it will be preserved on regeneration

__PACKAGE__->meta->make_immutable;
1;
