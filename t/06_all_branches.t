use strict;
use Test::More 0.98;
use utf8;

use Zengin::Perl;

my $zp = Zengin::Perl->new( { source_data_path => 't/source-data' } );

my $all_branches = $zp->all_branches();

my $branch = pop @{$all_branches};

is $branch->{bank_code}, '0001';
is $branch->{bank_name}, 'みずほ';
is $branch->{bank_hira}, 'みずほ';
is $branch->{bank_kana}, 'ミズホ';
is $branch->{bank_roma}, 'mizuho';
is $branch->{branch_code}, '001';
is $branch->{branch_name}, '東京営業部';
is $branch->{branch_hira}, 'とうきよう';
is $branch->{branch_kana}, 'トウキヨウ';
is $branch->{branch_roma}, 'toukiyou';

done_testing;

