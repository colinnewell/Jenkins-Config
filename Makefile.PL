use inc::Module::Install;

name     'Jenkins-Config';
all_from 'lib/Jenkins/Config.pm';
author   q{Colin Newell <colin.newell@gmail.com>};
license  'perl';

build_requires 'Test::More';
install_share 'lib/auto';

requires 'Jenkins::API';
requires 'XML::Compile';

install_as_cpan;
auto_install;
resources (
    repository => {
        url => 'ssh://git-server/srv/git/Jenkins-Config',
        type => 'git',
    },
);


WriteAll;

