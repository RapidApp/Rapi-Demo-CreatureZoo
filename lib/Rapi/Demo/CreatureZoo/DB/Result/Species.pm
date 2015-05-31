use utf8;
package Rapi::Demo::CreatureZoo::DB::Result::Species;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("species");
__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "diet_type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "ideal_wt_lbs",
  {
    data_type => "decimal",
    default_value => \"null",
    is_nullable => 1,
    size => [6, 2],
  },
  "min_sq_ft",
  {
    data_type => "decimal",
    default_value => \"null",
    is_nullable => 1,
    size => [8, 2],
  },
  "about",
  { data_type => "text", default_value => \"null", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("name_unique", ["name"]);
__PACKAGE__->has_many(
  "creatures",
  "Rapi::Demo::CreatureZoo::DB::Result::Creature",
  { "foreign.species_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "diet_type",
  "Rapi::Demo::CreatureZoo::DB::Result::DietType",
  { id => "diet_type_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-05-31 19:17:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:p9F+F0QKQ782vO1RpKf0qw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
