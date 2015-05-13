package Rapi::Demo::CreatureZoo::Module::CreaturePage;

use strict;
use warnings;

use Moose;
extends 'RapidApp::Module::DbicRowDV';

use RapidApp::Util qw(:all);
use Path::Class qw(file dir);

has '+template', default => 'templates/creature.html';

has '+tt_include_path', default => sub {
  my $self = shift;
  dir( $self->app->ra_builder->share_dir )->stringify;
};

1;

