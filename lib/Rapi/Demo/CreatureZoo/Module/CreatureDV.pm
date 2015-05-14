package Rapi::Demo::CreatureZoo::Module::CreatureDV;

use strict;
use warnings;

use Moose;
extends 'RapidApp::Module::AppDV';
with 'RapidApp::Module::StorCmp::Role::DbicLnk';

use RapidApp::Util qw(:all);
use Path::Class qw(file dir);

has '+include_colspec', default => sub {['*']};
has '+updatable_colspec', default => sub {['*']};
has '+destroyable_relspec', default => sub {['*']};

has 'ResultSource', is => 'ro', lazy => 1, default => sub {
  my $self = shift;
  $self->app->model('DB')->schema->source('Creature')
};

has '+tt_file', default => 'templates/creatures.html';

has '+tt_include_path', default => sub {
  my $self = shift;
  dir( $self->app->ra_builder->share_dir )->stringify;
};

sub BUILD {
  my $self = shift;
  
  $self->apply_extconfig( 
    itemSelector => 'div.dv-select',
    autoHeight => \0,
    autoScroll => \1,
    # -- Set a border for AutoPanel, and allow the template content to set:
    #  position:absolute;
    #  top: 0; right: 0; bottom: 0; left: 0;
    # ^^ and have it work as expected... OR postion 'relative' and scroll as expected:
    style => 'border: 1px solid #D0D0D0; position:relative;'
    # --
  );
}

1;

