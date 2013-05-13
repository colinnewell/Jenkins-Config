use inc::Module::Install;

name     'Jenkins-Config';
all_from 'lib/Jenkins/Config.pm';
author   q{Colin Newell <colin.newell@gmail.com>};
license  'perl';

build_requires 'Test::More';
install_script 'bin/jenkins_setup.pl';
install_script 'bin/test_with_deps.pl';
install_share 'lib/auto';

requires 'Jenkins::API';
requires 'CodeHacks';
requires 'XML::Compile';

install_as_cpan;
auto_install;
resources (
    repository => {
        url => 'ssh://bfwg.dyndns-at-home.com/~/git/Jenkins-Config',
        type => 'git',
    },
);


WriteAll;

