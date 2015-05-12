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
      grid_class => 'Rapi::Demo::CreatureZoo::Module::TableBase',
      grid_params => {
         '*defaults' => { # Defaults for all Sources
            updatable_colspec => ['*'],
            creatable_colspec => ['*'],
            destroyable_relspec => ['*']
         }, # ('*defaults')

      }, # (grid_params)
      TableSpecs => {
        Creature => {
          display_column => 'name',
          title => 'Creature',
          title_multi => 'Creatures',
          #iconCls => '',
          #multiIconCls => '',
          columns => {
            id            => {  },
            species_id    => { profiles => ['hidden'] },
            name          => {  },
            image_html    => {  
              header => 'Image',
              width => 110,
              renderer => join('','Ext.ux.RapidApp.getImgTagRendererDefault(',
                '"/assets/local/misc/static/img/noimage.jpg","autosize",150',
              ')'),
              editor => {
                xtype => 'cas-image-field',
                maxImageWidth => 300,
                maxImageHeight => 300,
                minHeight => 36,
                minWidth => 36,
                renderValFn => join('','Ext.ux.RapidApp.getImgTagRendererDefault(',
                  '"/assets/local/misc/static/img/noimage.jpg","autosize",150',
                ')')
              }
            },
            dob           => {  },
            high_risk     => {  },
            market_value  => {  },
            detail        => {  },
            enclosure_id  => { profiles => ['hidden'] },
            species       => {  },
            enclosure     => {  },
          }
        },
        CreatureWeightLog => {
          display_column => 'recorded',
          title => 'Weigt Log',
          title_multi => 'Weight Logs',
          #iconCls => '',
          #multiIconCls => '',
          columns => {
            id           => {  },
            creature_id  => { profiles => ['hidden'] },
            recorded     => {  },
            weight_lbs   => {  },
            comment      => {  },
            creature     => {  },
          }
        },
        Enclosure => {
          display_column => 'name',
          title => 'Enclosure',
          title_multi => 'Enclosures',
          #iconCls => '',
          #multiIconCls => '',
          columns => {
            id                  => {  },
            name                => {  },
            enclosure_class_id  => { profiles => ['hidden'] },
            length_ft           => {  },
            width_ft            => {  },
            height_ft           => {  },
            open_top            => {  },
            detail              => {  },
            enclosure_class     => {  },
          }
        },
        EnclosureClass => {
          display_column => 'classification',
          title => 'Enclosure Class',
          title_multi => 'Enclosure Classes',
          #iconCls => '',
          #multiIconCls => '',
          columns => {
            id             => {  },
            classification => {  }
          }
        },
        Species => {
          display_column => 'name',
          title => 'Species',
          title_multi => 'Species List',
          #iconCls => 'icon-worker',
          #multiIconCls => 'icon-workers',
          columns => {
            id     => {  },
            name   => {  },
            about  => {  },
          }
        },
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
