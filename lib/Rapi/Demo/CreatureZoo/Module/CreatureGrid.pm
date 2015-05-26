package Rapi::Demo::CreatureZoo::Module::CreatureGrid;

use strict;
use warnings;

use Moose;
extends 'RapidApp::Module::DbicGrid';

use RapidApp::Util qw(:all);

has '+include_colspec', default => sub {['*']};
has '+updatable_colspec', default => sub {['*']};
has '+creatable_colspec', default => sub {['*']};
has '+destroyable_relspec', default => sub {['*']};

#has '+persist_all_immediately', default => 1;
#has '+use_add_form', default => 'window';
has '+use_edit_form', default => 'window';

has '+persist_immediately', default => sub{{
  create  => 0,
  update  => 0,
  destroy => 0
}};

has 'ResultSource', is => 'ro', lazy => 1, default => sub {
  my $self = shift;
  $self->app->model('DB')->schema->source('Creature')
};


1;

