use utf8;
package Rapi::Demo::CreatureZoo::DB::Result::DietType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("diet_type");
__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "cls",
  {
    data_type => "varchar",
    default_value => \"null",
    is_nullable => 1,
    size => 16,
  },
  "about",
  { data_type => "text", default_value => \"null", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "species",
  "Rapi::Demo::CreatureZoo::DB::Result::Species",
  { "foreign.diet_type_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-05-30 18:47:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SWz9fxUQ2tgW7soiI62kQw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
