#!/usr/bin/perl -w

use lib 't/lib/';

use WebService::Freshservice::Test;
use Test::Most;
use Test::Warnings;

my $tester = WebService::Freshservice::Test->new();

$tester->test_with_dancer(\&user_testing, 7);

sub user_testing {
  my ($api,$message) = @_;

  pass("Freshservice Testing: $message");  
  use_ok("WebService::Freshservice");
  

  my $freshservice = WebService::Freshservice->new(
    apikey  => $api->apikey,
    apiurl  => $api->apiurl,
  );
  
  subtest 'Instantiation' => sub {
    isa_ok($freshservice, "WebService::Freshservice");
    
    can_ok($freshservice, qw( create_user user users ));
  };

  subtest 'Create User - Minimal Options' => sub {
    my $user = $freshservice->create_user(
      name  => "Test",
      email => 'test@example.com',
    );

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
  
  subtest 'Retrieve User' => sub {
    my $user = $freshservice->user( id => '1234567890' );
    is( $user->id, 1234567890, "'id' returned a value");
    is( $user->email, 'test@example.com', "'email' returned an email address");

    my $email = $freshservice->user( email => 'search@example.com' );
    is( $email->email, 'search@example.com', "Search via email returns correct result");
    
    my $invalid = $freshservice->user( id => '9999999999' );
    dies_ok { $invalid->name } "'user' method croaks on unknown user id";
    dies_ok { $freshservice->user() } "'user' method requires an id at a minimum";
    dies_ok { $freshservice->user( email => 'croak@example.com' ) } "'user' dies if no valid email found";
  };

  subtest 'Search Users' => sub {
    my $blank = $freshservice->users();
    is( (@{$blank})[1]->name, "Test 2", "Multiple users returned" );

    my $email = $freshservice->users( email => 'query@example.com'); 
    is( (@{$email})[0]->email, 'query@example.com', "User search based on email" );

    my $mobile = $freshservice->users( mobile => '0400000001'); 
    is( (@{$mobile})[0]->mobile, "0400000001", "User search based on mobile" );

    my $phone = $freshservice->users( phone => '0386521453'); 
    is( (@{$phone})[0]->phone, "0386521453", "User search based on phone" );

    my $all = $freshservice->users( 
      email => 'query@example.com',
      mobile => '0400000001',
      phone => '0386521453',
    ); 
    is( (@{$all})[0]->email, 'query@example.com', "Email returned from user multi query search" );
    is( (@{$all})[0]->mobile, "0400000001", "Mobile returned from user multi query search" );
    is( (@{$all})[0]->phone, "0386521453", "Phone returned from user multi query search" );
    
    my $deactivated = $freshservice->users( state => 'unverified' );
    is( (@{$deactivated})[0]->active, 0, "state 'unverified' returns inactive users" );
    
    my $deleted = $freshservice->users( state => 'deleted' );
    is( (@{$deleted})[0]->deleted, 1, "state 'deleted' returns deleted users" );
  };

  subtest 'Failures' => sub {
    dies_ok { $freshservice->_build__api('argurment') } "method '_build__api' doesn't accept arguments";
  };
}

done_testing();
__END__
