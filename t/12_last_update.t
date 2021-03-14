use strict;
use Test::More;
use utf8;
use File::Share 0.25 ':all';
use File::Slurp 9999.32 qw/read_file/;

use Zengin::Perl;
my $zp = Zengin::Perl->new();

my $update_at_path = dist_file( 'Zengin-Perl', 'data/updated_at' );
my $updated_at     = read_file($update_at_path);

is $zp->last_update, $updated_at;

done_testing;
