package Rapi::Demo::CreatureZoo::Module::CreatureDV;

use strict;
use warnings;

use Moose;
extends 'RapidApp::Module::DbicDV';

has '+include_colspec',     default => sub {['*']};
has '+updatable_colspec',   default => sub {['*']};
has '+creatable_colspec',   default => sub {['*']};
has '+destroyable_relspec', default => sub {['*']};

has '+persist_immediately', default => sub{{
  create  => 0, update  => 0, destroy => 0
}};

has 'ResultSource', is => 'ro', lazy => 1, default => sub {
  my $self = shift;
  $self->app->model('DB')->schema->source('Creature')
};

has '+tt_file', default => 'templates/creatures.html';

has '+tt_include_path', default => sub {
  my $self = shift;
  $self->app->ra_builder->share_dir
};

sub BUILD {
  my $self = shift;
  
  $self->apply_extconfig( 
    itemSelector  => 'div.dv-select',
    selectedClass => 'x-grid3-row-checked',
  );
}

1;
