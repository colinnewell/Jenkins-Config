use inc::Module::Install;

name     'Jenkins-Config';
all_from 'lib/Jenkins/Config.pm';
author   q{Colin Newell <colin.newell@gmail.com>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

