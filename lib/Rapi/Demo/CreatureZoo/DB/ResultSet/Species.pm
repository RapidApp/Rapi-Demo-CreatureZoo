package Rapi::Demo::CreatureZoo::DB::ResultSet::Species;
use parent 'DBIx::Class::ResultSet';

use RapidApp::Util qw(:all);

use strict;
use warnings;

sub chart_data_rs {
  (shift)
    ->search_rs(undef,{
      columns  => [
        { id        => 'me.id' },
        { name      => 'me.name' }, 
        { creatures => { count => 'creatures.id' } }
      ],
      join     => 'creatures',
      order_by => { -asc => 'me.name' },
      group_by => 'me.id'
    })
}

sub chart_data {
  return [ 
    (shift)
      ->chart_data_rs
      ->search_rs(undef,{ result_class => 'DBIx::Class::ResultClass::HashRefInflator' })
      ->all
  ]
}


sub chart_data_json {
  my $self = shift;
  encode_json_utf8( $self->chart_data );
}


1;
