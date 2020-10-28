#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

binmode STDOUT, ":utf8";

use Zengin::Perl;

# branch info
my $zp       = Zengin::Perl->new();
my $bank     = $zp->bank( bank_code => '0001' );
my $branches = $bank->branches;

my $branch = $branches->{'001'};

print $branch->code() . "\n";    # 001
print $branch->name() . "\n";    # 東京営業部
print $branch->hira() . "\n";    # とうきよう
print $branch->kana() . "\n";    # トウキヨウ
print $branch->roma() . "\n";    # toukiyou

