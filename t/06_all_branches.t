use strict;
use Test::More 0.98;
use utf8;

use Zengin::Perl;

my $zp = Zengin::Perl->new();

my @all_branches = ();

my $banks = $zp->banks();
for my $bank_code ( sort keys %{$banks} ) {
    my $bank = $banks->{$bank_code};

    my $branches = $bank->branches();

    for my $branch_code ( sort keys %{$branches} ) {
        my $branch = $branches->{$branch_code};
        push @all_branches, $branch;
    }
}

my $branch = $all_branches[0];

is $branch->code, '001';
is $branch->name, '東京営業部';
is $branch->hira, 'とうきよう';
is $branch->kana, 'トウキヨウ';
is $branch->roma, 'toukiyou';

done_testing;

