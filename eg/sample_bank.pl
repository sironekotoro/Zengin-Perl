#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

binmode STDOUT, ":utf8";

use Zengin::Perl;

# bank info
my $zp   = Zengin::Perl->new();
my $bank = $zp->bank( bank_code => '0001' );
print $bank->code() . "\n";    # 0001
print $bank->name() . "\n";    # みずほ
print $bank->hira() . "\n";    # みずほ
print $bank->kana() . "\n";    # ミズホ
print $bank->roma() . "\n";    # mizuho
