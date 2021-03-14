use strict;
use Test::More;
use utf8;

use Zengin::Perl;

my $zp = Zengin::Perl->new();

my $bank = $zp->bank(bank_code => '0001');

my $result = $bank->branch_name_search( branch_name => '東京' );

is $result->[0]->code , '001';
is $result->[1]->code , '078';
is $result->[2]->code , '110';
is $result->[3]->code , '253';
is $result->[4]->code , '622';
is $result->[5]->code , '777';

done_testing;
