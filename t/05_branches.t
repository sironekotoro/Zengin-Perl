use strict;
use Test::More;
use Test::Fatal 0.016;
use utf8;

use Zengin::Perl;

my $zp = Zengin::Perl->new();

my $bank     = $zp->bank( bank_code => '0001' );
my $branches = $bank->branches();
my $branch   = $branches->{'001'};

is $branch->{code}, '001';
is $branch->{name}, '東京営業部';
is $branch->{hira}, 'とうきよう';
is $branch->{kana}, 'トウキヨウ';
is $branch->{roma}, 'toukiyou';


# Nonexistent branch codes
like(
    exception {
        my $bank = $zp->bank( bank_code => '0001' );
        my $branch = $bank->branch( branch_code => '002' );
    },
    qr/no corresponding branch code/,
    "Nonexistent branch codes"
);


done_testing;

