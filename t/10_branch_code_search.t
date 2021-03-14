use strict;
use Test::More;
use utf8;

use Zengin::Perl;

my $zp = Zengin::Perl->new();

my $bank = $zp->bank(bank_code => '0001');

my $result = $bank->branch_code_search( branch_code => '001' );

is $result->name , '東京営業部';

done_testing;
