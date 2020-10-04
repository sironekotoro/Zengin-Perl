use strict;
use Test::More 0.98;
use utf8;

use Zengin::Perl;

my $zp = Zengin::Perl->new( { source_data_path => 't/source-data' } );

$zp->bank(1);
my $branches = $zp->branches();
my $branch = $branches->{'001'};

is $branch->{code}, '001';
is $branch->{name}, '東京営業部';
is $branch->{hira}, 'とうきよう';
is $branch->{kana}, 'トウキヨウ';
is $branch->{roma}, 'toukiyou';

done_testing;

