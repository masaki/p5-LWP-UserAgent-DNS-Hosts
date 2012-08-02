use inc::Module::Install;

name 'LWP-UserAgent-DNS-Hosts';
license 'perl';
all_from 'lib/LWP/UserAgent/DNS/Hosts.pm';

requires 'parent';
requires 'LWP::Protocol';
requires 'LWP::Protocol::http';
requires 'Guard';

recommends 'LWP::Protocol::https'; # for SSL impl and tests
recommends 'HTTP::Daemon::SSL';    # for SSL tests

tests 't/*.t';
test_requires 'Test::More' => 0.98;
test_requires 'Test::UseAllModules';
test_requires 'Test::Fake::HTTPD' => 0.04;
test_requires 'LWP::UserAgent';
test_requires 'File::Temp';

author_tests 'xt';
auto_set_repository;

WriteAll;
