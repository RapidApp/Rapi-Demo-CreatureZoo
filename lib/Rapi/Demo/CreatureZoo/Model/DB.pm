package Rapi::Demo::CreatureZoo::Model::DB;

use strict;
use warnings;

use Moo;
extends 'Catalyst::Model::DBIC::Schema';

use Try::Tiny;

__PACKAGE__->config(
    schema_class => 'Rapi::Demo::CreatureZoo::DB',
    
    connect_info => {
        #dsn => 'dbi:SQLite:creaturezoo.db', #<-- Note: this gets set in Rapi::Demo::CreatureZoo
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


sub _auto_deploy_schema {
  my $self = shift;
  my $schema = $self->schema;
  
  try {
    # This will barf if the table doesn't exist:
    $schema->resultset('Creature')->count;
  }
  catch {
    warn join("","\n",
      "  ** Auto-Deploying fresh schema ", (ref $self),'/',(ref $schema),' **',
      "\n"
    );
    
    $schema->txn_do( sub {
      $schema->deploy;
      $schema->_auto_populate if ($schema->can('_auto_populate')); #<-- future
    });
  };
};


1;
