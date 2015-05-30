use FindBin;
use lib "$FindBin::Bin/lib";

use Rapi::Demo::CreatureZoo;
my $app = Rapi::Demo::CreatureZoo->new(
  plugins => ['+Rapi::Demo::CreatureZoo::Util::Plugin::DemoAuthOvr']
);

# Plack/PSGI app:
$app->to_app
