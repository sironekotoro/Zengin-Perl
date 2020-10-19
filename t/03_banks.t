use strict;
use Test::More;
use utf8;

use Zengin::Perl;

my $zp = Zengin::Perl->new();

my $banks = $zp->banks();
my $bank  = $banks->{'0001'};

is $bank->{code}, '0001';
is $bank->{name}, 'みずほ';
is $bank->{hira}, 'みずほ';
is $bank->{kana}, 'ミズホ';
is $bank->{roma}, 'mizuho';

done_testing;

