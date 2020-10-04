use strict;
use Test::More 0.98;
use utf8;

use Zengin::Perl;

my $zp = Zengin::Perl->new( { source_data_path => './source-data' } );

can_ok $zp , 'new';
can_ok $zp , 'banks_file';
can_ok $zp , 'branches_folder';
can_ok $zp , 'bank';
can_ok $zp , 'banks';
can_ok $zp , 'branch';
can_ok $zp , 'branches';
can_ok $zp , 'all_branches';

done_testing;

