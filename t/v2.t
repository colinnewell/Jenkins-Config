use Test::Most;

use Jenkins::Config::V2;

my $cb = Jenkins::Config::V2->new();
my $xml = $cb->to_xml(
    $cb->default_project
);
is $xml, '<?xml version="1.0" encoding="UTF-8"?>
<project><actions/><description/><keepDependencies>false</keepDependencies><properties><com.coravy.hudson.plugins.github.GithubProjectProperty plugin="github@1.24.0"><projectUrl>http://example.com</projectUrl><displayName/></com.coravy.hudson.plugins.github.GithubProjectProperty></properties><scm class="hudson.plugins.git.GitSCM" plugin="git@3.0.1"><configVersion>2</configVersion><userRemoteConfigs><hudson.plugins.git.UserRemoteConfig><url>http://example.com</url><credentialsId>github</credentialsId></hudson.plugins.git.UserRemoteConfig></userRemoteConfigs><branches><hudson.plugins.git.BranchSpec><name>*/master</name></hudson.plugins.git.BranchSpec></branches><doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations><submoduleCfg class="list"/><extensions/></scm><canRoam>true</canRoam><disabled>false</disabled><blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding><blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding><triggers><com.cloudbees.jenkins.GitHubPushTrigger plugin="github@1.24.0"><spec/></com.cloudbees.jenkins.GitHubPushTrigger></triggers><concurrentBuild>false</concurrentBuild><builders><hudson.tasks.Shell><command>/opt/perl5/bin/cpanm --installdeps .
                /opt/perl5/bin/prove -l t --timer --formatter=TAP::Formatter::JUnit  &amp;gt; ${JOB_NAME}-${BUILD_NUMBER}-junit.xml</command></hudson.tasks.Shell></builders><publishers><hudson.tasks.junit.JUnitResultArchiver plugin="junit@1.19"><testResults>*junit.xml</testResults><keepLongStdio>false</keepLongStdio><healthScaleFactor>1</healthScaleFactor><allowEmptyResults>false</allowEmptyResults></hudson.tasks.junit.JUnitResultArchiver></publishers><buildWrappers><hudson.plugins.timestamper.TimestamperBuildWrapper plugin="timestamper@1.8.7"/></buildWrappers></project>
';
ok $cb->default_project;

done_testing;
