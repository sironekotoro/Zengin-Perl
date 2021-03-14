use strict;
use Test::More;
use utf8;

use Zengin::Perl;

my $zp = Zengin::Perl->new();

can_ok $zp , 'new';
can_ok $zp , 'banks_file';
can_ok $zp , 'bank';
can_ok $zp , 'banks';
can_ok $zp , 'branch';
can_ok $zp , 'branches';
can_ok $zp , 'bank_name_search';
can_ok $zp , 'bank_code_search';
can_ok $zp , 'branch_name_search';
can_ok $zp , 'branch_code_search';

done_testing;

