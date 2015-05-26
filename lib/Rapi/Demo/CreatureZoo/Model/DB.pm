package Rapi::Demo::CreatureZoo::Model::DB;

use strict;
use warnings;

use Moo;
extends 'Catalyst::Model::DBIC::Schema';

use RapidApp::Util qw(:all);

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
         Creature => {
            include_colspec => ['*','species.*']
         },
         CreatureWeightLog => {
            include_colspec => ['*','*.*']
         }

      }, # (grid_params)
      TableSpecs => {
        Creature => {
          display_column => 'name',
          title => 'Creature',
          title_multi => 'Creatures',
          iconCls => 'icon-bug-yellow',
          multiIconCls => 'icon-bugs-yellow',
          columns => {
            id            => { header => 'Id', width => 45, hidden => 1  },
            species_id    => { profiles => ['hidden'] },
            name          => { header => 'Name', width => 130 },
            image_html    => { header => 'Image', width => 110, profiles => ['cas_img'] },
            dob           => { header => 'DOB',   },
            high_risk     => { header => 'High Risk?',   },
            market_value  => { header => 'Market Value', width => 100, profiles => ['money'] },
            detail        => { header => 'Details', hidden => 1,   profiles => ['html'] },
            enclosure_id  => { profiles => ['hidden'],             profiles => ['hidden'] },
            species       => { header => 'Species',  width => 130    },
            enclosure     => { header => 'Enclosure', width => 130   },
            creature_weight_logs => { header => 'Weight Logs' },
            last_weight   => { header => 'Last Weight (lbs)', width => 110 },
            quick_record_weight => { 
              header => 'Quick Log Weight', width => 105, 
              hidden => 1, allow_add => 0, sortable => 0,
              renderer => jsfunc join('','function(v){',
                'return \'<span class="ra-null-val"><i>Enter lbs</i></span>\';',
              '}')
            },
            weight_chart => {
              header => 'Weight History [Line Chart]', 
              width => 420, hidden => 1, sortable => 0,
              renderer => 'Ext.ux.CreatureZoo.renderWeightChart'
            }
          }
        },
        CreatureWeightLog => {
          display_column => 'recorded',
          title => 'Weigt Log',
          title_multi => 'Weight Logs',
          iconCls => 'icon-history',
          multiIconCls => 'icon-history',
          columns => {
            id           => { header => 'Id', width => 45 },
            creature_id  => { profiles => ['hidden'] },
            recorded     => { header => 'Recorded' },
            weight_lbs   => { header => 'Weight (lbs)' },
            comment      => { header => 'Comments' },
            creature     => { header => 'Creature' },
          }
        },
        Enclosure => {
          auto_editor_type => 'combo',
          display_column => 'name',
          title => 'Enclosure',
          title_multi => 'Enclosures',
          iconCls => 'icon-jar',
          multiIconCls => 'icon-jars',
          columns => {
            id                  => { header => 'Id',   width => 45  },
            name                => { header => 'Name', width => 120   },
            enclosure_class_id  => { profiles => ['hidden'] },
            length_ft           => { header => 'Length (ft)',   },
            width_ft            => { header => 'Width (ft)',   },
            height_ft           => { header => 'Height (ft)',   },
            open_top            => { header => 'Open Top?',   },
            detail              => { hidden => 1, header => 'Details',   },
            enclosure_class     => { header => 'Enclosure Class',   },
          }
        },
        EnclosureClass => {
          display_column => 'classification',
          title => 'Enclosure Class',
          title_multi => 'Enclosure Classes',
          iconCls => 'icon-enc-class',
          multiIconCls => 'icon-enc-classes',
          columns => {
            id             => { header => 'Id'  },
            classification => { header => 'Classification' }
          }
        },
        Species => {
          display_column => 'name',
          title => 'Species',
          title_multi => 'Species List',
          iconCls => 'icon-panda',
          multiIconCls => 'icon-panda',
          columns => {
            id         => { header => 'Id', width => 45  },
            name       => { header => 'Name', width => 110  },
            about      => { header => 'About', width => 350, hidden => 1, profiles => ['html']  },
            creatures  => { header => 'Creatures' }
          }
        },
      }, # (TableSpecs)
      virtual_columns => {
        Creature => {
          last_weight => {
            data_type => "decimal", 
            is_nullable => 1, 
            size => [6, 2],
            sql => join(' ',
              'SELECT weight_lbs FROM creature_weight_log',
              'WHERE creature_id = self.id',
              'ORDER BY recorded DESC LIMIT 1'
            )
          },
          quick_record_weight => {
            data_type => "decimal", 
            is_nullable => 1, 
            size => [6, 2],
            sql => 'SELECT NULL',
            set_function => sub {
              my ($row, $value) = @_;
              $row->creature_weight_logs->create({
                creature_id => $row->id,
                recorded    => DateTime->now( time_zone => 'local' ),
                weight_lbs  => $value,
                comment     => 'Quick-Recorded'
              })
            },
          },
          weight_chart => {
            data_type => "varchar", 
            is_nullable => 1, 
            size => 255,
            sql => join(' ',
              'SELECT GROUP_CONCAT(recorded || "/" || weight_lbs) AS listing',
              'FROM creature_weight_log',
              'WHERE creature_id = self.id',
            )
          }
        }

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
