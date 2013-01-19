use Test::Most;

BEGIN {
    unless ($ENV{LIVE_TEST_JENKINS_URL})
    {
        plan skip_all => 'Set LIVE_TEST_JENKINS_URL if you want to run these tests against a live jenkins server';
    }
}
use Jenkins::API;
use Jenkins::Config;
my $url = $ENV{LIVE_TEST_JENKINS_URL};
my $api = Jenkins::API->new(base_url => $url);

my $cb = Jenkins::Config->new();
my $hash = $cb->default_project;
my $xml = $cb->to_xml($hash);
ok $api->create_job('Test-Project', $xml);
$api->trigger_build('Test-Project');
ok $api->set_project_config('Test-Project', $xml);
ok $api->delete_project('Test-Project');

done_testing;

