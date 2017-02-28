requires 'LWP::Protocol';
requires 'LWP::Protocol::http';
requires 'Scope::Guard';
requires 'parent';
requires 'perl', '5.008001';

on build => sub {
    requires 'ExtUtils::MakeMaker', '6.59';
    requires 'File::Temp';
    requires 'LWP::UserAgent';
    requires 'Test::Fake::HTTPD', '0.06';
    requires 'Test::More', '0.98';
    requires 'Test::UseAllModules';
};
