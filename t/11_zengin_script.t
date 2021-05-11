use strict;
use Test::More;
use utf8;
use Encode;

use Zengin::Perl;

my $arg_count_zero_result = `perl script/zengin`;
like  (decode_utf8($arg_count_zero_result), qr/GETTING STARTED/);

my $arg_count_one_result = `perl script/zengin みずほ`;
like  (decode_utf8($arg_count_one_result), qr/0001/);

my $arg_count_two_result = `perl script/zengin みずほ 横浜`;
like  (decode_utf8($arg_count_two_result), qr/357/);

my $arg_count_two_result = `perl script/zengin ゆうちょ 〇八八`;
like  (decode_utf8($arg_count_two_result), qr/088/);

my $arg_count_two_result = `perl script/zengin 9900 〇八八`;
like  (decode_utf8($arg_count_two_result), qr/9900/);

my $arg_count_two_result = `perl script/zengin 9900 088`;
like  (decode_utf8($arg_count_two_result), qr/ゆうちょ/);

my $arg_count_two_result = `perl script/zengin ＰａｙＰａｙ`;
like  (decode_utf8($arg_count_two_result), qr/0033/);

my $arg_count_two_result = `perl script/zengin PayPay`;
like  (decode_utf8($arg_count_two_result), qr/0033/);

my $arg_count_two_result = `perl script/zengin paypay`;
like  (decode_utf8($arg_count_two_result), qr/0033/);

my $arg_count_two_result = `perl script/zengin 33`;
like  (decode_utf8($arg_count_two_result), qr/0033/);

my $arg_count_two_result = `perl script/zengin 三菱ＵＦＪ`;
like  (decode_utf8($arg_count_two_result), qr/0005/);

my $arg_count_two_result = `perl script/zengin 三菱UFJ`;
like  (decode_utf8($arg_count_two_result), qr/0005/);

my $arg_count_two_result = `perl script/zengin 三菱ufj`;
like  (decode_utf8($arg_count_two_result), qr/0005/);

my $arg_count_two_result = `perl script/zengin 三菱`;
like  (decode_utf8($arg_count_two_result), qr/0005/);


done_testing;