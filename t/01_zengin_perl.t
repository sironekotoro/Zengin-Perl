use strict;
use Test::More;
use utf8;

use Zengin::Perl;

my $zp = Zengin::Perl->new();

can_ok $zp , 'new';
can_ok $zp , 'banks_file';
can_ok $zp , 'bank';
can_ok $zp , 'banks';
can_ok $zp , 'bank_search';

done_testing;

