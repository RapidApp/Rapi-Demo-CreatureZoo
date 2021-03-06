#!/usr/bin/perl

use strict;
use warnings;

use DBIx::Class::Schema::Loader;
use Module::Runtime;

use FindBin;
use lib "$FindBin::Bin/../lib";

my $approot = "$FindBin::Bin/..";
my $applib = "$approot/lib";
my $ddl = "$approot/sql/creaturezoo.sql";
my $sqlt = "$approot/creaturezoo_data/creaturezoo.db";

my $model_class = 'Rapi::Demo::CreatureZoo::Model::DB';
Module::Runtime::require_module($model_class);
my $schema_class = $model_class->config->{schema_class};

my $cmd = "sqlite3 $sqlt < $ddl";
print "$cmd\n";
qx{$cmd};
die "\n  --> Non-zero (" . ($? >> 8) . ') exit!! ' if ($?);

print "\nDumping schema '$schema_class' to '$applib'";


DBIx::Class::Schema::Loader::make_schema_at(
  $schema_class, 
  {
    debug => 1,
    dump_directory => $applib,
    use_moose	=> 1, generate_pod => 0,
    components => ["InflateColumn::DateTime"],
  },
  [ 
    "dbi:SQLite:$sqlt",'','',
    { loader_class => 'RapidApp::Util::MetaKeys::Loader' }
  ]
);

print "\n";

