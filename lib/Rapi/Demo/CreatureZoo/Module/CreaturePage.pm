package Rapi::Demo::CreatureZoo::Module::CreaturePage;

use strict;
use warnings;

use Moose;
extends 'RapidApp::Module::DbicPropPage';

use RapidApp::Util qw(:all);

# TODO


before 'content' => sub {
  my $self = shift;
  
  $self->apply_extconfig( tabTitle => $self->req_Row->name );
};

1;

