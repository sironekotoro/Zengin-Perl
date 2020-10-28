#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

binmode STDOUT, ":utf8";

use Zengin::Perl;

# branches info
my $zp       = Zengin::Perl->new();
my $bank     = $zp->bank( bank_code => '0001' );
my $branches = $bank->branches;

for my $branch_code ( sort keys %{$branches} ) {
    my $branch = $branches->{$branch_code};
    print join "\t", $branch->code, $branch->name . "\n";

}

# 001 東京営業部
# 004 丸の内中央
# 005 丸之内
# 009 神田駅前
# 013 町村会館出張所