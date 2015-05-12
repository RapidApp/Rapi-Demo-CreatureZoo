package Rapi::Demo::CreatureZoo::Module::TableBase;

use strict;
use warnings;

use Moose;
extends 'Catalyst::Plugin::RapidApp::RapidDbic::TableBase';

use RapidApp::Util qw(:all);

has 'page_class', is => 'ro', lazy => 1, default => sub {
  my $self = shift;
  my $class = 'RapidApp::Module::DbicPropPage';
  
  my $source_name = $self->ResultSource->source_name;
  
  $class = 'Rapi::Demo::CreatureZoo::Module::CreaturePage' 
    if ($source_name eq 'Creature');
  
  $class
}, isa => 'Str';



1;

