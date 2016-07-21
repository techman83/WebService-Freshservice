#!/usr/bin/perl -w

use lib 't/lib/';

use WebService::Freshservice::Test;
use Test::Most;
use Test::Warnings;

my $tester = WebService::Freshservice::Test->new();

$tester->test_with_dancer(\&user_testing, 7);

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
    
    #can_ok($user, qw(retrieve create update update_attr activate
    #  deactivate delete));
  };
  
  subtest 'Retrieved Values' => sub {
    is( $user->active, 1, "'active' returned true");
    is( $user->address, undef, "'address' returned 'undef'");
    is( $user->created_at, '2016-07-11T16:02:28+08:00', "'created_at' returned a raw date");
    ok( $user->custom_field, "'custom_field' exists");
    is( $user->deleted, 0, "'deleted' returned false");
    is( $user->department_names, '', "'department_names' returned empty");
    is( $user->description, undef, "'description' returned undef");
    is( $user->email, 'test@example.com', "'email' returned an email address");
    is( $user->external_id, 123456, "'external_id' returned a value");
    is( $user->helpdesk_agent, 0, "'helpdesk_agent' returned false");
    is( $user->id, 1234567890, "'id' returned a value");
    is( $user->job_title, undef, "'job_title' returned undef");
    is( $user->language, 'en', "'language' returned a value");
    is( $user->location_name, undef, "'location_name' returned undef");
    is( $user->mobile, undef, "'mobile' returned undef");
    is( $user->name, "Test", "'name' returned a value");
    is( $user->phone, undef, "'mobile' returned undef");
    is( $user->time_zone, 'Perth', "'time_zone' returned a value");
    is( $user->updated_at, '2016-07-18T09:28:47+08:00', "'updated_at' returned a raw date");
  };
   
  subtest 'Failures' => sub {
    dies_ok { $user->_build_user('argument') } "method '_build_user' doesn't accept arguments";
    dies_ok { $user->_build__raw('argurment') } "method '_build__raw' doesn't accept arguments";
  };
}

done_testing();
__END__
