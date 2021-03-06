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
        #dsn => 'dbi:SQLite:creaturezoo.db'
        user => '',
        password => '',
        sqlite_unicode => q{1},
        on_connect_call => q{use_foreign_keys},
        quote_names => q{1},
    }
);


__PACKAGE__->config( RapidDbic => {

  hide_fk_columns => 1,
  grid_class => 'Rapi::Demo::CreatureZoo::Module::TableBase',
  grid_params => {
     '*defaults' => { # Defaults for all Sources
        updatable_colspec => ['*'],
        creatable_colspec => ['*'],
        destroyable_relspec => ['*']
     }, # ('*defaults')
     Creature => {
        include_colspec => ['*','species.*','species.diet_type.cls']
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
        id         => { header => 'Id', width => 45, hidden => 1  },
        species_id => { profiles => ['hidden'] },
        name       => { header => 'Name', width => 130 },
        image      => { 
          header => 'Image', width => 110, 
          profiles => ['cas_img'] 
        },
        attachment    => { 
          header => 'Attachment', width => 110, 
          profiles => ['cas_link'] 
        },
        dob => { header => 'DOB',   },
        high_risk => { header => 'High Risk?',   },
        market_value  => { 
          header => 'Market Value', width => 100, 
          profiles => ['money'] 
        },
        detail        => { 
          header => 'Details', hidden => 1, 
          profiles => ['html'] 
        },
        enclosure_id  => { profiles => ['hidden'] },
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
          renderer => 'RA.ux.cZoo.renderWeightChart'
        },
        age_years => { header => 'Age (years)', width => 80 }
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
        recorded     => { header => 'Recorded', width => 140 },
        weight_lbs   => { header => 'Weight (lbs)', width => 100 },
        comment      => { header => 'Comments', width => 175 },
        creature     => { header => 'Creature', width => 140 },
      }
    },
    DietType => {
      display_column => 'name',
      auto_editor_type => 'combo',
      title => 'Diet Type',
      title_multi => 'Diet Types',
      #iconCls => '',
      #multiIconCls => '',
      columns => {
        id     => { header => 'Id', width => 45, hidden => 1 },
        name   => { header => 'Name', width => 110 },
        cls    => { header => 'Cls (CSS)', width => 100 },
        about  => { 
          header => 'About', width => 300, 
          profiles => ['html'], hidden => 1 
        },
        creature_count => { header => "# Creatures", width => 85 },
        species => { header => "Species", width => 150 }
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
        creatures           => { header => 'Creatures' }
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
        classification => { header => 'Classification' },
        enclosures     => { header => 'Enclosures' }
      }
    },
    Species => {
      display_column => 'name',
      title => 'Species',
      title_multi => 'Species List',
      iconCls => 'icon-panda',
      multiIconCls => 'icon-panda',
      columns => {
        id           => { header => 'Id', width => 45  },
        name         => { header => 'Name', width => 160  },
        ideal_wt_lbs => { header => 'Ideal Wt (lbs)', width => 90 },
        min_sq_ft    => { header => 'Min Sq Feet', width => 85 },
        about        => { 
          header => 'About', width => 350, 
          hidden => 1, profiles => ['html']  
        },
        diet_type_id => { profiles => ['hidden'] },
        diet_type    => { header => 'Diet Type', width => 110 },
        creatures    => { header => 'Creatures' }
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
      },
      age_years => {
        data_type => "integer", 
        is_nullable => 0, 
        size => 255,
        sql => join(' ',
          # this is like "floor"
          "SELECT cast(((julianday('now') - julianday(self.dob))/365) as int)",
        )
      }
    },
    DietType => {
      # We could have created a multi-level has_many for this, but that could hit
      # the db a lot harder, and we don't need a full-blown rel to join, etc, we
      # just want to get the count so we can use it for the dashboard pie chart
      creature_count => {
        data_type => "integer", 
        is_nullable => 0, 
        size => 255,
        sql => join(' ',
          "SELECT COUNT(*) FROM creature",
          "JOIN species ON species.id = creature.species_id",
          "WHERE species.diet_type_id = self.id"
        )
      }
    }

  }, # (virtual_columns)
}); # (RapidDbic)


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
