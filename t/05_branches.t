use strict;
use Test::More 0.98;
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

done_testing;

