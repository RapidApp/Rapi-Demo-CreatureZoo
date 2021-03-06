use utf8;
package Rapi::Demo::CreatureZoo::DB::Result::Creature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("creature");
__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "species_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "image",
  { data_type => "text", default_value => \"null", is_nullable => 1 },
  "attachment",
  { data_type => "text", default_value => \"null", is_nullable => 1 },
  "dob",
  { data_type => "date", is_nullable => 0 },
  "high_risk",
  { data_type => "boolean", default_value => 0, is_nullable => 0 },
  "market_value",
  {
    data_type => "decimal",
    default_value => \"null",
    is_nullable => 1,
    size => [14, 2],
  },
  "detail",
  { data_type => "text", default_value => \"null", is_nullable => 1 },
  "enclosure_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "creature_weight_logs",
  "Rapi::Demo::CreatureZoo::DB::Result::CreatureWeightLog",
  { "foreign.creature_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "enclosure",
  "Rapi::Demo::CreatureZoo::DB::Result::Enclosure",
  { id => "enclosure_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);
__PACKAGE__->belongs_to(
  "species",
  "Rapi::Demo::CreatureZoo::DB::Result::Species",
  { id => "species_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-05-30 09:23:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2TpYS5T37QKEVNwZ6iC0Jw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
