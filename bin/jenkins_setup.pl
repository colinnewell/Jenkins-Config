#!/usr/bin/perl

use Modern::Perl;

use Jenkins::Config;
use CodeHacks::META;
use Jenkins::API;

# FIXME: add command line parsing or something.
# allow config xml to be produced without pushing to 
# url
# also allow just commands to be displayed.
my $url = shift;
die 'Must specify jenkins url' unless $url;
my $meta = shift;
die 'Must specify META.yml' unless $meta;

my $module = CodeHacks::META->new({ file_name => $meta });
die 'Must have source repo specified in META.yml' unless $module->repo_url;
my $deps = $module->local_deps;

my $cb = Jenkins::Config->new();
my $hash = $cb->default_project;
$hash->{description} = $module->abstract;
# FIXME: add svn support
if($module->repo_type eq 'git')
{
    $hash->{scm}->{userRemoteConfigs}->{'hudson.plugins.git.UserRemoteConfig'}->{url} = $module->repo_url;
}
my $shell_commands = $hash->{builders}->{'hudson.tasks.Shell'};
if($deps)
{
    my $cpan_line = $shell_commands->[1]->{command};
    my $lib = join ':', map { "../$_/lib" } @$deps;
    $cpan_line = sprintf "PERL5LIB=%s %s", $lib, $cpan_line;
    $shell_commands->[1]->{command} = $cpan_line;
    print "$cpan_line\n";
    my $prove_line = $shell_commands->[2]->{command};
    my $deps = join ' ', map { "-I ../$_/lib" } @$deps;
    $prove_line =~ s|(/opt/perl5/bin/prove)|$1 $deps|;
    print "$prove_line\n";
    $shell_commands->[2]->{command} = $prove_line;
}
# FIXME: add dependencies.

my $xml = $cb->to_xml($hash);

my $jenkins = Jenkins::API->new({ base_url => $url });
die 'Jenkins not running on ' . $url unless $jenkins->check_jenkins_url;
$jenkins->create_job($module->name, $xml) || die 'Unable to create project';
print "Project created\n";
#print $xml;

