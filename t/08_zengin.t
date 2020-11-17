use strict;
use Test::More;
use utf8;
use Encode;

use Zengin::Perl;


my $arg_count_zero_result = `perl script/zengin`;
like  (decode_utf8($arg_count_zero_result), qr/GETTING STARTED/);

my $arg_count_one_result = `perl script/zengin みずほ`;
like  (decode_utf8($arg_count_one_result), qr/0001: みずほ/);

my $arg_count_two_result = `perl script/zengin みずほ 横浜`;
like  (decode_utf8($arg_count_two_result), qr/0001: みずほ 357: 横浜/);

done_testing;