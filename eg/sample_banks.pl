#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

binmode STDOUT, ":utf8";

use Zengin::Perl;

# banks info
my $zp    = Zengin::Perl->new();
my $banks = $zp->banks;

for my $bank_code ( sort keys %{$banks} ) {
    my $bank = $banks->{$bank_code};
    print join "\t", $bank->code, $bank->name . "\n";
}

# 0001    みずほ
# 0005    三菱ＵＦＪ
# 0009    三井住友
# 0010    りそな
# ...