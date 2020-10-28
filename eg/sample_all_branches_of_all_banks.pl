#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

binmode STDOUT, ":utf8";

use Zengin::Perl;

# all branches of all banks
my $zp    = Zengin::Perl->new();
my $banks = $zp->banks;

for my $bank_code ( sort keys %{$banks} ) {
    my $bank = $zp->bank( bank_code => $bank_code );
    print join "\t", $bank->code, $bank->name . "\n";

    my $branches = $bank->branches;
    for my $branch_code (sort keys %{$branches}){
        my $branch = $branches->{$branch_code};

        print "\t", join "\t", $branch->code, $branch->name . "\n";

    }
}

# 0001    みずほ
#     001 東京営業部
#     004 丸の内中央
#     005 丸之内
#     ...
# 0005    三菱ＵＦＪ
#     001 本店
#     002 丸の内
#     003 瓦町
#     ...
