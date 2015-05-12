package Rapi::Demo::CreatureZoo;

use strict;
use warnings;

# ABSTRACT: RapidApp::Builder demo application

use RapidApp 1.0400;

use Moose;
extends 'RapidApp::Builder';

use Types::Standard qw(:all);

use RapidApp::Util ':all';
use File::ShareDir qw(dist_dir);
use FindBin;
use Path::Class qw(file dir);
use Module::Runtime;

our $VERSION = '0.001';

has '+base_appname', default => sub { 'CreatureZoo::App' };
has '+debug',        default => sub {1};

sub _build_plugins {[ 'RapidApp::RapidDbic' ]}

has 'share_dir', is => 'ro', isa => Str, lazy => 1, default => sub {
  my $self = shift;
  $ENV{RAPI_DEMO_CREATUREZOO_SHARE_DIR} || (
    try{dist_dir('Rapi-Demo-CreatureZoo')} || (
      -d "$FindBin::Bin/share" ? "$FindBin::Bin/share" : "$FindBin::Bin/../share" 
    )
  )
};


has 'creaturezoo_db', is => 'ro', isa => Str, lazy => 1, default => sub {
  my $self = shift;
  # Default to the cwd
  file( 'creaturezoo.db' )->stringify
};


has '+inject_components', default => sub {
  my $self = shift;
  my $model = 'Rapi::Demo::CreatureZoo::Model::DB';
  
  my $db = file( $self->creaturezoo_db );

  Module::Runtime::require_module($model);
  $model->config->{connect_info}{dsn} = "dbi:SQLite:$db";

  return [
    [ $model => 'Model::DB' ]
  ]
};


after 'bootstrap' => sub {
  my $self = shift;
  
  my $c = $self->appname;
  $c->model('DB')->_auto_deploy_schema
};


1;


__END__

=head1 NAME

Rapi::Demo::CreatureZoo - PSGI version of the RapidApp "CreatureZoo" demo

=head1 SYNOPSIS

 use Rapi::Demo::CreatureZoo;
 my $app = Rapi::Demo::CreatureZoo->new;

 # Plack/PSGI app:
 $app->to_app

Or, from the command-line:

 plackup -MRapi::Demo::CreatureZoo -e 'Rapi::Demo::CreatureZoo->new->to_app'


=head1 DESCRIPTION

...

=head1 CONFIGURATION

C<Rapi::Demo::CreatureZoo> extends L<RapidApp::Builder> and supports all of its options, as well as the 
following params specific to this module:

=head2 creaturezoo_db

Path to the SQLite database file, which may or may not already exist. If the file does not already
exist, it is created as a copy from the default database from the sharedir.

Defaults to C<'creaturezoo.db'> in the current working directory.

=head1 METHODS

=head2 init_db

Copies the default database to the path specified by C<creaturezoo_db>. Pass a true value as the first
argument to overwrite the target file if it already exists.

This method is called automatically the first time the module is loaded, or if the C<creaturezoo_db> file
doesn't exist.

=head1 SEE ALSO

=over

=item * 

L<RapidApp>

=item * 

L<RapidApp::Builder>

=back


=head1 AUTHOR

Henry Van Styn <vanstyn@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by IntelliTree Solutions llc.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut



