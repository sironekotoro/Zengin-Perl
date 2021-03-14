#!/usr/bin/env perl
use strict;
use warnings;

use Data::Dumper;
binmode STDIN,  ":utf8";
binmode STDOUT, ":utf8";

use File::Copy qw/move/;

my $updated_at_file = 'share/data/updated_at';
my $zengin_perl     = 'lib/Zengin/Perl.pm';
my $temp_file       = 'author/temp.pl';

for my $file ( $updated_at_file, $zengin_perl ) {
    die "$file not found.\n" if ( !-e $file );
}

# zengin-data のアップデート日
my $updated_at = get_updated_at();

# アップデート日を書き換えたスクリプト
my $updated_script = script_version_updataer($updated_at);

# 仮のファイルに出力
write_tempfile( $temp_file, $updated_script );

# 出力したファイルをチェック
check_tempfile($temp_file);

# ファイルを上書きする
write_up_file( $temp_file, $zengin_perl );

# ファイルを置き換える
sub get_updated_at {
    open my $FH, '<', $updated_at_file;
    for my $line (<$FH>) {
        chomp $line;
        $updated_at = $line;
    }
    close $FH;

    if ( !$updated_at =~ /\d{8}/ ) {
        die "updated_at parse error.\n";
    }

    return $updated_at;

}

# アップデート日を書き換える
sub script_version_updataer {
    my $updated_at = shift;
    open( my $READ, "<:utf8", $zengin_perl )
        or die "script file read error.\n";
    my $script = do { local $/; <$READ> };

    # our $VERSION = "0.10.20201029";
    my $regex = qr/our\s+\$VERSION\s+=\s+\"(?<version>\d+\.\d+\.(?<date>\d{8}))\"/;

    if ( $script =~ /$regex/ ) {
        $script =~ s/$+{date}/$updated_at/;

    }
    else {
        die "parse error.¥n";

    }

    return $script;
}

# 一時ファイルに書き出す
sub write_tempfile {
    my ( $temp_file, $updated_script ) = @_;

    open my $FH, '>:utf8', $temp_file or die "temp file read error.\n";
    print $FH $updated_script;
    close $FH;
}

# ファイルをチェックする
sub check_tempfile {
    my $temp_file = shift;

    open( my $READ, "<:utf8", $temp_file )
        or die "script file read error.\n";

    my $command = 'perl -wc ' . $temp_file;

    open my $rs, "$command 2>&1 |";
    my @rlist = <$rs>;
    close $rs;
    my $result = join '', @rlist;

    die "$temp_file Syntax error.\n" if ( !$result =~ /syntax\s+OK/ );

    return 1;
}

# ファイルを上書きする
sub write_up_file {
    my ( $temp_file, $zengin_perl ) = @_;

    move($temp_file, $zengin_perl ) or die "copy fail\n";

}
