package Rapi::Demo::CreatureZoo::Template::Access;
use strict;
use warnings;

use RapidApp::Util qw(:all);

use Moo;

extends 'RapidApp::Template::Access';

around 'get_template_vars' => sub {
  my ($orig,$self,@args) = @_;
  
  my $vars = $self->$orig(@args);
  
  # use a CodeRef so its only called when the template actually uses it:
  $vars->{species_chart_data_json} = sub {
    my $c = RapidApp->active_request_context or return undef;
    $c->model('DB::Species')->chart_data_json;
  };
  
  return $vars;
};

1;