package WebService::Freshservice::Test::User;

use Dancer2;

post '/itil/requesters.json' => sub {
  my $user->{user} = config->{testdata}{user};
  return $user;
};

get '/itil/requesters/:id' => sub {
  my $user->{user} = config->{testdata}{user};
  return $user;
};

put '/itil/requesters/:id' => sub {
  my $data = from_json(request->body);
  my $user->{user} = config->{testdata}{user};

  return $user;
};

del '/itil/requesters/:id' => sub {
  return 1;
};

get '/organization/user/search' => sub {
  my $user->{users} = [ config->{testdata}{user} ];
  return $user;
};

get '/organization/user' => sub {
  my $user->{users} = [ config->{testdata}{user} ];
  return $user;
};

1;
