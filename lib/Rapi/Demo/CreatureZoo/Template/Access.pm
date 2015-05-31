package Rapi::Demo::CreatureZoo::Template::Access;
use strict;
use warnings;

use RapidApp::Util qw(:all);

use Moo;

extends 'RapidApp::Template::Access';

around 'get_template_vars' => sub {
  my ($orig,$self,@args) = @_;
  
  my $vars = $self->$orig(@args);
  
  # use CodeRefs so they are only called when a template actually uses them:
  
  $vars->{species_chart_data_json} = sub {
    my $c = RapidApp->active_request_context or return undef;
    $c->model('DB::Species')->chart_data_json;
  };
  
  $vars->{diet_type_data} = sub {
    my $c = RapidApp->active_request_context or return undef;
    encode_json_utf8({ map { 
      $_->name => { $_->get_columns } 
    } $c->model('DB::DietType')->all })
  };
  
  return $vars;
};

1;