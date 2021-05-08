use strict;
use Test::More;
use utf8;
use File::Share 0.25 'dist_file';

use Zengin::Perl;
my $zp = Zengin::Perl->new();

my $update_at_path = dist_file( 'Zengin-Perl', 'data/updated_at' );

my $updated_at;
open my $FH, '<', $update_at_path or die;
{
    local $/;
    $updated_at = <$FH>;
}
close $FH;

is $zp->last_update, $updated_at;

done_testing;
