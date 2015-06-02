package Rapi::Demo::CreatureZoo;

use strict;
use warnings;

# ABSTRACT: RapidApp::Builder demo application

use RapidApp 1.0401_14;

use Moose;
extends 'RapidApp::Builder';

use Types::Standard qw(:all);

use RapidApp::Util ':all';
use File::ShareDir qw(dist_dir);
use Path::Class qw(file dir);
use Module::Runtime;
use Scalar::Util 'blessed';
use Cwd;

my $Bin = file($0)->parent; # Like FindBin

our $VERSION = '0.001';

has '+base_appname', default => sub { 'CreatureZoo::App' };
has '+debug',        default => sub {1};

sub _build_base_plugins {[
  'RapidApp::RapidDbic',
  'RapidApp::AuthCore',
  'RapidApp::NavCore',
  'RapidApp::CoreSchemaAdmin',
]}

sub _build_base_config {
  my $self = shift;
  
  $self->_init_local_data unless (-d $self->data_dir);

  return {
    'RapidApp' => {
      local_assets_dir => $self->_assets_dir,
      load_modules => {
        creatures     => 'Rapi::Demo::CreatureZoo::Module::CreatureDV',
        creature_grid => 'Rapi::Demo::CreatureZoo::Module::CreatureGrid'
      }
    },
    'Plugin::RapidApp::AuthCore' => {
      login_logo_url => '/assets/local/misc/static/img/creaturezoo_login_logo.png'
    },
    'Plugin::RapidApp::TabGui' => {
      title              => 'Creature Zoo Intranet',
      right_footer       => join('',(ref $self),' v',$VERSION),
      nav_title_iconcls  => 'icon-panda',
      navtree_init_width => 195,
      banner_template    => file($self->_tpl_dir,'banner.html')->stringify,
      dashboard_url      => '/tple/dashboard',
    },
    'Controller::RapidApp::Template' => {
      include_paths => $self->_template_include_paths,
      default_template_extension => 'html',
      access_class  => 'Rapi::Demo::CreatureZoo::Template::Access',
    },
    'Controller::SimpleCAS' => {
      store_path	=> $self->cas_store_dir
    },
    'Model::RapidApp::CoreSchema' => {
      sqlite_file => file( $self->coreschema_db )->absolute->stringify
    }
  }
}

has 'share_dir', is => 'ro', isa => Str, lazy => 1, default => sub {
  my $self = shift;
  $ENV{RAPI_DEMO_CREATUREZOO_SHARE_DIR} || (
    try{dist_dir('Rapi-Demo-CreatureZoo')} || (
      -d "$Bin/share" ? "$Bin/share" : "$Bin/../share" 
    )
  )
};

has 'data_dir', is => 'ro', isa => Str, lazy => 1, default => sub {
  my $self = shift;
  # Default to the cwd
  dir( cwd(), 'creaturezoo_data')->stringify;
};

has 'creaturezoo_db', is => 'ro', isa => Str, lazy => 1, default => sub {
  my $self = shift;
  file( $self->data_dir, 'creaturezoo.db' )->stringify
};

has 'coreschema_db', is => 'ro', isa => Str, lazy => 1, default => sub {
  my $self = shift;
  file( $self->data_dir, 'rapidapp_coreschema.db' )->stringify
};

has 'cas_store_dir', is => 'ro', isa => Str, lazy => 1, default => sub {
  my $self = shift;
  dir( $self->data_dir, 'cas_store' )->stringify
};

has 'local_template_dir', is => 'ro', isa => Str, lazy => 1, default => sub {
  my $self = shift;
  dir( $self->data_dir, 'templates' )->stringify
};


has '_template_include_paths', is => 'ro', lazy => 1, default => sub {
  my $self = shift;
  
  # overlay local, writable templates with installed, 
  # read-only templates installed in the share dir
  return [ $self->local_template_dir, $self->_tpl_dir ];
}, isa => ArrayRef[Str];


has '_assets_dir', is => 'ro', lazy => 1, default => sub {
  my $self = shift;
  
  my $loc_assets_dir = join('/',$self->share_dir,'assets');
  -d $loc_assets_dir or die join('',
    "assets dir ($loc_assets_dir) not found; ", 
    __PACKAGE__, " may not be installed properly.\n"
  );
  
  return $loc_assets_dir;
}, isa => Str;

has '_tpl_dir', is => 'ro', lazy => 1, default => sub {
  my $self = shift;
  
  my $tpl_dir = join('/',$self->share_dir,'templates');
  -d $tpl_dir or die join('',
    "template dir ($tpl_dir) not found; ", 
    __PACKAGE__, " may not be installed properly.\n"
  );
  
  return $tpl_dir;
}, isa => Str;

has '_init_data_dir', is => 'ro', isa => Str, lazy => 1, default => sub {
  my $self = shift;
  dir( $self->share_dir, '_init_data_dir' )->stringify
}, init_arg => undef;



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

sub _init_local_data {
  my ($self, $ovr) = @_;
  
  my ($src,$dst) = (dir($self->_init_data_dir),dir($self->data_dir));
  
  die "_init_local_data(): ERROR: init data dir '$src' not found!" unless (-d $src);

  if(-d $dst) {
    if($ovr) {
      $dst->rmtree;
    }
    else {
      die "_init_cas(): Destination dir '$dst' already exists -- call with true arg to overwrite.";
    }
  }
  
  print STDERR "\n Initializing local data_dir $dst/\n" if ($self->debug);
  
  $self->_recurse_copy($src,$dst);
  
  print STDERR "\n" if ($self->debug);
}


sub _recurse_copy {
  my ($self, $Src, $Dst, $lvl) = @_;
  
  $lvl ||= 0;
  $lvl++;
  
  die "Destination path '$Dst' already exists!" if (-e $Dst);
  
  print STDERR join('',
    '  ',('  ' x $lvl),$Dst->basename,
    $Dst->is_dir ? '/' : '', "\n"
  ) if ($self->debug);

  if($Src->is_dir) {
    $Dst->mkpath;
    for my $Child ($Src->children) {
      my $meth = $Child->is_dir ? 'subdir' : 'file';
      $self->_recurse_copy($Child,$Dst->$meth($Child->basename),$lvl);
    }
  }
  else {
    $Dst->spew( scalar $Src->slurp );
  }
}

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



