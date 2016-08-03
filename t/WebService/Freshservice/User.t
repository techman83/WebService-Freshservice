#!/usr/bin/perl -w

use lib 't/lib/';

use WebService::Freshservice::Test;
use Test::Most;
use Test::Warnings;

my $tester = WebService::Freshservice::Test->new();

$tester->test_with_dancer(\&user_testing, 9);

sub user_testing {
  my ($api,$message) = @_;

  pass("User Testing: $message");  
  use_ok("WebService::Freshservice::User");
  

  my $user = WebService::Freshservice::User->new(
    api  => $api,
    id   => '1234567890',
  );
  
  subtest 'Instantiation' => sub {
    isa_ok($user, "WebService::Freshservice::User");
    
    can_ok($user, qw( delete_requester ) );
  };
  
  subtest 'Retrieved Values' => sub {
    is( $user->active, 1, "'active' returned true");
    is( $user->address, "An Address", "'address' returned a value");
    is( $user->created_at, '2016-07-11T16:02:28+08:00', "'created_at' returned a raw date");
    ok( $user->custom_field, "'custom_field' exists");
    is( $user->deleted, 0, "'deleted' returned false");
    is( $user->department_names, '', "'department_names' returned empty");
    is( $user->description, "I'm Testy McTestFace", "'description' returned a value");
    is( $user->email, 'test@example.com', "'email' returned an email address");
    is( $user->external_id, 123456, "'external_id' returned a value");
    is( $user->helpdesk_agent, 0, "'helpdesk_agent' returned false");
    is( $user->id, 1234567890, "'id' returned a value");
    is( $user->job_title, "Tester of Things", "'job_title' returned a value");
    is( $user->language, 'en', "'language' returned a value");
    is( $user->location_name, "Testland", "'location_name' returned a value");
    is( $user->mobile, "0406000000", "'mobile' returned a value");
    is( $user->name, "Test", "'name' returned a value");
    is( $user->phone, "0386521453", "'phone' returned a value");
    is( $user->time_zone, 'Perth', "'time_zone' returned a value");
    is( $user->updated_at, '2016-07-18T09:28:47+08:00', "'updated_at' returned a raw date");
  };

  subtest 'Actions' => sub {
    is( $user->delete_requester, 1, "Requester deletes work correctly" );
  };
  
  subtest 'Attribute Clearing' => sub {
    $user->_clear_all;
    my @attributes = qw( 
      active created_at custom_field deleted department_names 
      helpdesk_agent updated_at address description email external_id 
      language location_name job_title mobile name phone time_zone _raw
    );
    foreach my $attr (@attributes) {
      is( $user->{$attr}, undef, "Attribute '$attr' was cleared" );
    }
  };
   
  subtest 'Attribute Updating' => sub {
    my $update = WebService::Freshservice::User->new(
      api  => $api,
      id   => '1337',
    );
    is( $update->name, "Test", "Name correct on initial population" );
    $update->name('Elite');
    $update->update_requester;
    is( $update->name, "Elite", "Name correct post object update" );
    $update->update_requester( attr => 'name', value => 'Dangerous' );
    is( $update->name, "Dangerous", "Individual attribute update completed" );
    my @attributes = qw( 
      active created_at custom_field deleted department_names 
      helpdesk_agent updated_at
    );
    foreach my $attr (@attributes) {
      dies_ok { $user->update_requester( attr => $attr, value => "update" ) } "'$attr' is non writeable, croaks accordingly";
    }
  };

  subtest 'Failures' => sub {
    dies_ok { $user->_build_user('argument') } "method '_build_user' doesn't accept arguments";
    dies_ok { $user->_build__raw('argurment') } "method '_build__raw' doesn't accept arguments";
    dies_ok { $user->_build__attributes('argurment') } "method '_build__attributes' doesn't accept arguments";
    dies_ok { $user->_clear_all('argurment') } "method '_clear_all' doesn't accept arguments";
  };
}

done_testing();
__END__
