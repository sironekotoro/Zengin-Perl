use strict;
use Test::More;
use utf8;

use Zengin::Perl;

my $zp = Zengin::Perl->new();

my $result = $zp->bank_search( bank_name => 'みずほ' );

is $result->[0]->name, 'みずほ';
is $result->[1]->name, 'みずほ信託';
is $result->[2]->name, '埼玉みずほ農協';

done_testing;

