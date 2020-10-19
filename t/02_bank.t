use strict;
use Test::More;
use Test::Fatal 0.016;
use utf8;

use Zengin::Perl;

my $zp = Zengin::Perl->new();

my $bank = $zp->bank( bank_code => '0001' );

is $bank->code(), '0001';
is $bank->name(), 'みずほ';
is $bank->hira(), 'みずほ';
is $bank->kana(), 'ミズホ';
is $bank->roma(), 'mizuho';

# Nonexistent bank codes
like(
    exception {
        my $bank = $zp->bank( bank_code => '0002' )
    },
    qr/no corresponding bank code/,
    "Nonexistent bank codes"
);

done_testing;

