use utf8;
package Rapi::Demo::CreatureZoo::DB::Result::CreatureWeightLog;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("creature_weight_log");
__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "creature_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "recorded",
  { data_type => "datetime", is_nullable => 0 },
  "weight_lbs",
  { data_type => "decimal", is_nullable => 0, size => [6, 2] },
  "comment",
  { data_type => "text", default_value => \"null", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "creature",
  "Rapi::Demo::CreatureZoo::DB::Result::Creature",
  { id => "creature_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-05-11 19:15:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CvOzHskTYNjTpkJv4Okpnw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
