#!/usr/bin/env perl
use strict;
use Test::More;
use utf8;
use Encode qw/decode/;

use FindBin;
use File::Spec;

my $x = File::Spec->catfile( $FindBin::Bin, '../script/' );
chdir $x;

# =====================================
# テストパターン：zengin 0001 001
# =====================================

my $bankcode_branchcode = decode( 'utf8', `perl zengin 0001 001` );

my $result = << 'EOS';
============================
銀行コード　　　　: 0001
銀行名　　　　　　: みずほ
銀行名（ひらがな）: みずほ
銀行名（カタカナ）: ミズホ
銀行名（ローマ字）: mizuho
============================
支店コード　　　　: 001
支店名　　　　　　: 東京営業部
支店名（ひらがな）: とうきよう
支店名（カタカナ）: トウキヨウ
支店名（ローマ字）: toukiyou
EOS

is $result, $bankcode_branchcode;

# =====================================
# テストパターン：zengin みずほ 001
# =====================================

my $bankname_branchcode = decode( 'utf8', `perl zengin みずほ 001` );

$result = << 'EOS';
============================
銀行コード　　　　: 0001
銀行名　　　　　　: みずほ
銀行名（ひらがな）: みずほ
銀行名（カタカナ）: ミズホ
銀行名（ローマ字）: mizuho
============================
支店コード　　　　: 001
支店名　　　　　　: 東京営業部
支店名（ひらがな）: とうきよう
支店名（カタカナ）: トウキヨウ
支店名（ローマ字）: toukiyou
EOS

is $result, $bankname_branchcode;

# =====================================
# テストパターン：zengin 0001 東京営業部
# =====================================

my $bankcode_branchname = decode( 'utf8', `perl zengin 0001 東京営業部` );

$result = << 'EOS';
0001	みずほ	001	東京営業部
EOS

is $result, $bankcode_branchname;

# =====================================
# テストパターン：zengin みずほ 東京営業部
# =====================================

my $bankname_branchname = decode( 'utf8', `perl zengin みずほ 東京営業部` );

is $result, $bankname_branchname;

done_testing;
