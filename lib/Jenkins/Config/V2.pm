package Jenkins::Config::V2;

our $VERSION = '0.01';

=head1 DESCRIPTION

This is a module for creating the XML for the config files for a 
project in Jenkins.

I<This modules interface is very likely to change. I've currently
implemented the bare minimum to get the API working but I'm
of the opinion it currently sucks.  How to fix that I'm not sure
yet.  The first order of business is to tidy up the XSD and get
the XML generation solid.  Once that's done I'll understand what
I can build and hopefully build a decent API for the Builder.>

=head1 METHODS

=head2 to_xml

This is a simple method that takes a hash and produces xml for it
using the internal XSD for the XML file.  It will choke if any
required elements are missing.

I<This is still very much under development.  The XSD used to produce
the XML probably needs a lot of refinement.  It was generated from
a single Jenkins config file and is therefore likely to only contain
the options I had selected.  It may also be the case that I can make
a lot of the options optional, in which case I should be able to 
reduce the complexity of the hash required.>  

    my $cb = Jenkins::Config::V2->new();
    my $xml = $cb->to_xml(
        {
            actions => {},
            description => {},
            keepDependencies => "false",
            properties =>
            {
                'com.coravy.hudson.plugins.github.GithubProjectProperty' =>
                {
                    plugin => "github@1.24.0",
                    projectUrl => "http://example.com",
                    displayName => {}, 
                }, 
            },

            scm =>
            {
                class => "hudson.plugins.git.GitSCM",
                plugin => "git@3.0.1",
                configVersion => 2,
                userRemoteConfigs =>
                {

                    # is an unnamed complex
                    'hudson.plugins.git.UserRemoteConfig' =>
                    {
                        url => "http://example.com",
                        credentialsId => "github", }, },
                branches =>
                { # sequence of hudson.plugins.git.BranchSpec

                    # is an unnamed complex
                    'hudson.plugins.git.BranchSpec' =>
                    {
                        name => "*/master", }, },
                doGenerateSubmoduleConfigurations => "false",
                submoduleCfg =>
                {
                    class => "list", },
                extensions => {}, },
            canRoam => "true",
            disabled => "false",
            blockBuildWhenDownstreamBuilding => "false",
            blockBuildWhenUpstreamBuilding => "false",
            triggers =>
            { # sequence of com.cloudbees.jenkins.GitHubPushTrigger
                'com.cloudbees.jenkins.GitHubPushTrigger' =>
                { # is a xs:anyType
                    # attribute plugin is required
                    plugin => "github@1.24.0",

                    # sequence of spec

                    # is an unnamed complex
                    spec => {}, }, },

            # is a xs:boolean
            concurrentBuild => "false",

            # is an unnamed complex
            builders =>
            {
                'hudson.tasks.Shell' =>
                {
                    command => "/opt/perl5/bin/cpanm --installdeps .
                    /opt/perl5/bin/prove -l t --timer --formatter=TAP::Formatter::JUnit  &gt; \${JOB_NAME}-\${BUILD_NUMBER}-junit.xml", }, },
            publishers =>
            {
                'hudson.tasks.junit.JUnitResultArchiver' =>
                {
                    plugin => "junit@1.19",
                    testResults => "*junit.xml",
                    keepLongStdio => "false",
                    healthScaleFactor => 1.0,
                    allowEmptyResults => "false", 
                }, 
            },

            buildWrappers =>
            {
                'hudson.plugins.timestamper.TimestamperBuildWrapper' =>
                {
                    plugin => "timestamper@1.8.7", 
                }, 
            }, 
        }
    );

=head2 default_project

Returns a hash containing the default information it needs.  It may
be easiest to get this hash and then amend the details you are 
interested in.


=cut

use Moose;
use XML::Compile::Schema;
use XML::LibXML;
use File::ShareDir;

sub to_xml
{
    my $self = shift;
    my $hash = shift;
    my $config_spec = File::ShareDir::module_file(__PACKAGE__, 'v2config.xsd');
    my $schema = XML::Compile::Schema->new($config_spec);
    # FIXME: can we product the configs in a more human 
    # readable form?
    my $doc = XML::LibXML::Document->new('1.0', 'UTF-8');
    my $writer = $schema->compile(WRITER => 'project');
    my $xml = $writer->($doc, $hash);
    $doc->setDocumentElement($xml);
    return $doc->toString();
}

sub default_project
{
    my $self = shift;
    return
    {
        actions => {},
        description => {},
        keepDependencies => "false",
        properties =>
        {
            'com.coravy.hudson.plugins.github.GithubProjectProperty' =>
            {
                plugin => 'github@1.24.0',
                projectUrl => "http://example.com",
                displayName => {}, 
            }, 
        },

        scm =>
        {
            class => "hudson.plugins.git.GitSCM",
            plugin => 'git@3.0.1',
            configVersion => 2,
            userRemoteConfigs =>
            {

                # is an unnamed complex
                'hudson.plugins.git.UserRemoteConfig' =>
                {
                    url => "http://example.com",
                    credentialsId => "github", }, },
            branches =>
            { # sequence of hudson.plugins.git.BranchSpec

                # is an unnamed complex
                'hudson.plugins.git.BranchSpec' =>
                {
                    name => "*/master", }, },
            doGenerateSubmoduleConfigurations => "false",
            submoduleCfg =>
            {
                class => "list", },
            extensions => {}, },
        canRoam => "true",
        disabled => "false",
        blockBuildWhenDownstreamBuilding => "false",
        blockBuildWhenUpstreamBuilding => "false",
        triggers =>
        { # sequence of com.cloudbees.jenkins.GitHubPushTrigger
            'com.cloudbees.jenkins.GitHubPushTrigger' =>
            { # is a xs:anyType
                # attribute plugin is required
                plugin => 'github@1.24.0',

                # sequence of spec

                # is an unnamed complex
                spec => {}, }, },

        # is a xs:boolean
        concurrentBuild => "false",

        # is an unnamed complex
        builders =>
        {
            'hudson.tasks.Shell' =>
            {
                command => "/opt/perl5/bin/cpanm --installdeps .
                /opt/perl5/bin/prove -l t --timer --formatter=TAP::Formatter::JUnit  &gt; \${JOB_NAME}-\${BUILD_NUMBER}-junit.xml", }, },
        publishers =>
        {
            'hudson.tasks.junit.JUnitResultArchiver' =>
            {
                plugin => 'junit@1.19',
                testResults => "*junit.xml",
                keepLongStdio => "false",
                healthScaleFactor => 1.0,
                allowEmptyResults => "false", 
            }, 
        },

        buildWrappers =>
        {
            'hudson.plugins.timestamper.TimestamperBuildWrapper' =>
            {
                plugin => 'timestamper@1.8.7', 
            }, 
        }, 
    }
}

1;
