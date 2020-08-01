# NAME

Zengin::Perl - The perl implementation of ZenginCode.

# SETUP & SAMPLE

    $ git clone git@github.com:sironekotoro/Zengin-Perl.git

    $ cd Zengin-Perl

    $ git submodule init

    $ git submodule update

    $ cd eg/

    $ perl sample.pl

# SYNOPSIS

    use Zengin::Perl;
    binmode STDOUT, ":utf8";

    my $zp = Zengin::Perl->new();

    # bank info
    my $bank = $zp->bank(1);
    print $bank->code() . "\n"; # 0001
    print $bank->name() . "\n"; # みずほ
    print $bank->hira() . "\n"; # みずほ
    print $bank->kana() . "\n"; # ミズホ
    print $bank->roma() . "\n"; # mizuho


    # branch info
    my $branch = $zp->branch(1);
    print $branch->code . "\n"; # 001
    print $branch->name . "\n"; # 東京営業部
    print $branch->hira . "\n"; # とうきよう
    print $branch->kana . "\n"; # トウキヨウ
    print $branch->roma . "\n"; # toukiyou


    # branch list
    my $branches = $zp->branches();
    while ( my ( $branch_code, $branch_info ) = each %{$branches} ) {
        print $branch_code , ':', $branch_info->roma . "\n";
    }
    # 693:naha
    # 440:oosaka
    # 001:toukiyou
    # 660:fukuoka
    # 813:satsuporo
    # ...


    # all branch list (return ARRAYREF)
    my $all_branch = $zp->all_branches();
    for my $branch (
        sort {
                   $a->{bank_code} <=> $b->{bank_code}
                or $a->{branch_code} <=> $b->{branch_code}
        } @{$all_branch}
        )
    {
        print "=" x 20 . "\n";
        print "$branch->{bank_code}"   . "\n";
        print "$branch->{bank_roma}"   . "\n";
        print "$branch->{branch_code}" . "\n";
        print "$branch->{branch_roma}" . "\n";
        print "=" x 20 . "\n";
    }

# DESCRIPTION

The perl implementation of ZenginCode.

ZenginCode is datasets of bank codes and branch codes for japanese.

# LICENSE

Copyright (C) sironekotoro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

sironekotoro <develop@sironekotoro.com>
