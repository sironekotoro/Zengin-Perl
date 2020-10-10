# NAME

Zengin::Perl - The perl implementation of ZenginCode.

# INSTALLATION

    cpanm git@github.com:sironekotoro/Zengin-Perl.git

# SYNOPSIS

    use Zengin::Perl;
    binmode STDOUT, ":utf8";

    my $zp = Zengin::Perl->new();

    # bank info
    my $bank = $zp->bank( bank_code => 0001 );
    print $bank->code() . "\n";    # 0001
    print $bank->name() . "\n";    # みずほ
    print $bank->hira() . "\n";    # みずほ
    print $bank->kana() . "\n";    # ミズホ
    print $bank->roma() . "\n";    # mizuho

    # banks
    my $banks = $zp->banks();
    while ( my ( $bank_code, $bank_info ) = each %{$banks} ) {
        print "=" x 20 . "\n";
        print $bank_info->{code} . "\n";
        print $bank_info->{roma} . "\n";
        print "=" x 20 . "\n";
    }

    # branch info
    $bank = $zp->bank( bank_code => 0001 );
    my $branch = $bank->branch( branch_code => 001 );
    print $branch->code() . "\n";    # 001
    print $branch->name() . "\n";    # 東京営業部
    print $branch->hira() . "\n";    # とうきよう
    print $branch->kana() . "\n";    # トウキヨウ
    print $branch->roma() . "\n";    # toukiyou

    # branch list
    $bank = $zp->bank( bank_code => 0001 );
    my $branches = $bank->branches();
    while ( my ( $branch_code, $branch_info ) = each %{$branches} ) {
        print $branch_code , ':', $branch_info->roma . "\n";
    }

# DESCRIPTION

The perl implementation of ZenginCode.

ZenginCode is Datasets of bank codes and branch codes for japanese.

# LICENSE

Copyright (C) sironekotoro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

sironekotoro <develop@sironekotoro.com>
