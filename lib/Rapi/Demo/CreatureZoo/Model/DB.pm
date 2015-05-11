package Rapi::Demo::CreatureZoo::Model::DB;

use strict;
use warnings;

use Moo;
extends 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'Rapi::Demo::CreatureZoo::DB',
    
    connect_info => {
        dsn => 'dbi:SQLite:creaturezoo.db', #<-- Note: this gets changed in Rapi::Demo::CreatureZoo
        user => '',
        password => '',
        sqlite_unicode => q{1},
        on_connect_call => q{use_foreign_keys},
        quote_names => q{1},
    },
    
    RapidDbic => {
      hide_fk_columns => 1,
      grid_params => {
         '*defaults' => { # Defaults for all Sources
            updatable_colspec => ['*'],
            creatable_colspec => ['*'],
            destroyable_relspec => ['*']
         }, # ('*defaults')

      }, # (grid_params)
      TableSpecs => {

      }, # (TableSpecs)
      virtual_columns => {

      }, # (virtual_columns)
   } # (RapidDbic)
);


1;
