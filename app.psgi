BEGIN {
  use Path::Class qw/file dir/;
  $Bin = file($0)->parent->stringify; # Like FindBin
  $lib = "$Bin/lib";
}

use lib $lib;

use Rapi::Demo::CreatureZoo;
my $app = Rapi::Demo::CreatureZoo->new(
  plugins => [
    '+Rapi::Demo::CreatureZoo::Util::Plugin::DemoAuthOvr'
  ],
  data_dir => "$Bin/creaturezoo_data"
);

# Plack/PSGI app:
$app->to_app
