use utf8;
package Rapi::Demo::CreatureZoo::DB::Result::Enclosure;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("enclosure");
__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "enclosure_class_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "length_ft",
  {
    data_type => "decimal",
    default_value => \"null",
    is_nullable => 1,
    size => [8, 2],
  },
  "width_ft",
  {
    data_type => "decimal",
    default_value => \"null",
    is_nullable => 1,
    size => [8, 2],
  },
  "height_ft",
  {
    data_type => "decimal",
    default_value => \"null",
    is_nullable => 1,
    size => [8, 2],
  },
  "open_top",
  { data_type => "boolean", is_nullable => 0 },
  "detail",
  { data_type => "text", default_value => \"null", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("name_unique", ["name"]);
__PACKAGE__->has_many(
  "creatures",
  "Rapi::Demo::CreatureZoo::DB::Result::Creature",
  { "foreign.enclosure_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "enclosure_class",
  "Rapi::Demo::CreatureZoo::DB::Result::EnclosureClass",
  { id => "enclosure_class_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07040 @ 2015-05-12 11:55:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:f9k5PYJys45fbQBNSjXecg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
