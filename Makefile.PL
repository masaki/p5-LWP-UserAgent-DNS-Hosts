use inc::Module::Install;

name 'LWP-Protocol-Hosts';
license 'perl';
all_from 'lib/LWP/Protocol/Hosts.pm';

requires 'LWP::Protocol';
requires 'LWP::Protocol::http';
requires 'Guard';

recommends 'LWP::Protocol::https'; # for SSL tests
recommends 'HTTP::Daemon::SSL';    # for SSL tests

tests 't/*.t';
test_requires 'Test::More' => 0.98;
test_requires 'Test::UseAllModules';
test_requires 'Test::Fake::HTTPD' => 0.04;
test_requires 'LWP::UserAgent';
test_requires 'LWP::Simple';

author_tests 'xt';
auto_set_repository;

WriteAll;
