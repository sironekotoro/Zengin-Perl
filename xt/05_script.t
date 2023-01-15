#!/usr/bin/env perl
use strict;
use Test::More;
use utf8;
use Encode qw/decode/;

use FindBin;
use File::Spec;

my $script_dir = File::Spec->catfile( $FindBin::Bin, '../script/' );
chdir $script_dir;

# =====================================
# テストパターン：zengin 0001
# =====================================

my $bankcode_branchcode = decode( 'utf8', `perl zengin 0001` );

my $result = << 'EOS';
============================
銀行コード　　　　: 0001
銀行名　　　　　　: みずほ
銀行名（ひらがな）: みずほ
銀行名（カタカナ）: ミズホ
銀行名（ローマ字）: mizuho
EOS

is $result, $bankcode_branchcode;

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
# テストパターン：zengin 0001 東京営業部
# =====================================

my $bankcode_branchname = decode( 'utf8', `perl zengin 0001 東京営業部` );

$result = << 'EOS';
0001	みずほ	001	東京営業部
EOS

is $result, $bankcode_branchname;

# =====================================
# テストパターン：zengin みずほ
# =====================================

my $bankname = decode( 'utf8', `perl zengin みずほ` );

$result = << 'EOS';
============================
銀行コード　　　　: 0001
銀行名　　　　　　: みずほ
銀行名（ひらがな）: みずほ
銀行名（カタカナ）: ミズホ
銀行名（ローマ字）: mizuho
============================
銀行コード　　　　: 0289
銀行名　　　　　　: みずほ信託
銀行名（ひらがな）: みずほしんたく
銀行名（カタカナ）: ミズホシンタク
銀行名（ローマ字）: mizuhoshintaku
============================
銀行コード　　　　: 4859
銀行名　　　　　　: 埼玉みずほ農協
銀行名（ひらがな）: さいたまみずほのうきよう
銀行名（カタカナ）: サイタマミズホノウキヨウ
銀行名（ローマ字）: saitamamizuhonoukiyou
EOS

is $result, $bankname;

# =====================================
# テストパターン：zengin みずほ 001
# =====================================

my $bankname_branchcode = decode( 'utf8', `perl zengin みずほ 001` );

$result = << 'EOS';
0001	みずほ	001	東京営業部
4859	埼玉みずほ農協	001	本店
EOS

is $result, $bankname_branchcode;

# =====================================
# テストパターン：zengin みずほ 東京
# =====================================

my $bankname_branchname = decode( 'utf8', `perl zengin みずほ 東京` );

$result = << 'EOS';
0001	みずほ	001	東京営業部
0001	みずほ	078	東京法人営業部
0001	みずほ	110	東京中央
0001	みずほ	253	東京ファッションタウン出張所
0001	みずほ	622	東京中央市場内出張所
0001	みずほ	777	東京都庁出張所
EOS

is $result, $bankname_branchname;

# =====================================
# テストパターン：zengin 0001 東京
# =====================================

my $bankname_branchname = decode( 'utf8', `perl zengin みずほ 東京` );

$result = << 'EOS';
0001	みずほ	001	東京営業部
0001	みずほ	078	東京法人営業部
0001	みずほ	110	東京中央
0001	みずほ	253	東京ファッションタウン出張所
0001	みずほ	622	東京中央市場内出張所
0001	みずほ	777	東京都庁出張所
EOS

is $result, $bankname_branchname;

# =====================================
# テストパターン：zengin 001
# =====================================

my $bankname_branchname = decode( 'utf8', `perl zengin 001` );

$result = << 'EOS';
GETTING STARTED
  # 引数が1つ：銀行検索
    zengin みずほ
    zengin 0001

  # 引数が2つ：銀行ごとの支店検索
    zengin みずほ 東京
    zengin 0001 001
EOS

# =====================================
# テストパターン：zengin 00001
# =====================================

my $bankname_branchname = decode( 'utf8', `perl zengin 00001` );

$result = << 'EOS';
GETTING STARTED
  # 引数が1つ：銀行検索
    zengin みずほ
    zengin 0001

  # 引数が2つ：銀行ごとの支店検索
    zengin みずほ 東京
    zengin 0001 001
EOS

done_testing;
