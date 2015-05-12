use FindBin;
use lib "$FindBin::Bin/lib";

use Rapi::Demo::CreatureZoo;
my $app = Rapi::Demo::CreatureZoo->new;

# Plack/PSGI app:
$app->to_app
