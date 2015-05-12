package Rapi::Demo::CreatureZoo::Module::CreaturePage;

use strict;
use warnings;

use Moose;
extends 'RapidApp::Module::AppDV';
with 'RapidApp::Module::StorCmp::Role::DbicLnk::RowPg';

use RapidApp::Util qw(:all);
use Path::Class qw(file dir);


sub BUILD {
  my $self = shift;
  $self->apply_extconfig( itemSelector => 'div.dvitem' );
}

has '+allow_restful_queries', default => 1;

has '+tt_include_path', default => sub {
  my $self = shift;
  dir( $self->app->ra_builder->share_dir )->stringify;
};

has '+tt_file', default => 'templates/creature.html';

before 'content' => sub {
  my $self = shift;
  
  $self->apply_extconfig( tabTitle => $self->req_Row->name );
};

1;

