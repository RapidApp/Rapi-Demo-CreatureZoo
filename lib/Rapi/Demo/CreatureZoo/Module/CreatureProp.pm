package Rapi::Demo::CreatureZoo::Module::CreatureProp;

use strict;
use warnings;

use Moose;
extends 'RapidApp::Module::DbicPropPage';

use RapidApp::Util qw(:all);

has '+include_colspec', default => sub {['*','species.*','species.diet_type.cls']};
has '+updatable_colspec', default => sub {['*']};
has '+creatable_colspec', default => sub {['*']};
has '+destroyable_relspec', default => sub {['*']};

has '+persist_immediately', default => sub{{
  create  => 1,
  update  => 1,
  destroy => 1
}};

has 'ResultSource', is => 'ro', lazy => 1, default => sub {
  my $self = shift;
  $self->app->model('DB')->schema->source('Creature')
};

before 'content' => sub {
  my $self = shift;
  if(my $Row = $self->req_Row) {
    $self->apply_extconfig( tabTitle => $Row->name );
  }

};


1;

