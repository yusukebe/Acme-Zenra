use inc::Module::Install;
name 'Acme-Zenra';
all_from 'lib/Acme/Zenra.pm';

requires 'Carp';
requires 'URI';
requires 'LWP::UserAgent';
requires 'XML::Simple';
requires 'Encode';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
