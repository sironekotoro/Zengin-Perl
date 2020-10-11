use strict;
use Test::More 0.98;
use utf8;

use Zengin::Perl;

my $zp = Zengin::Perl->new();

my $result = $zp->search('みずほ');

is $result->[0]->name, 'みずほ';
is $result->[1]->name, 'みずほ信託';
is $result->[2]->name, '埼玉みずほ農協';

done_testing;

