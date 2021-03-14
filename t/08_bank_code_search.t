use strict;
use Test::More;
use utf8;

use Zengin::Perl;

my $zp = Zengin::Perl->new();

my $result = $zp->bank_code_search( bank_code => '0001' );

is $result->name, 'みずほ';

done_testing;
