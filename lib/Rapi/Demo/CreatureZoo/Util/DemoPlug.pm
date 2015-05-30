package Rapi::Demo::CreatureZoo::Util::DemoPlug;
use Moose::Role;
use namespace::autoclean;

use RapidApp::Util qw(:all);

# This is a special plugin for demo use only -- will auto-login, if needed,
# whenever the query-string param 'auth_ovr' flag is set (true value)

before 'dispatch' => sub {
  my $c = shift;
  
  if($c->req->params->{auth_ovr}) {
    if(my $AuthC = $c->controller('Auth')) {
      unless ($c->session && $c->session_is_valid and $c->user_exists) {
        $AuthC->do_login($c,'admin','pass');
      }
    }
  }

};


1;
