use utf8;
package Rapi::Demo::CreatureZoo::DB::Result::EnclosureClass;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("enclosure_class");
__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "classification",
  { data_type => "varchar", is_nullable => 0, size => 32 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("classification_unique", ["classification"]);
__PACKAGE__->has_many(
  "enclosures",
  "Rapi::Demo::CreatureZoo::DB::Result::Enclosure",
  { "foreign.enclosure_class_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07040 @ 2015-05-12 11:55:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Usjj8Z7HfXzT5bW/gJSMkA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
