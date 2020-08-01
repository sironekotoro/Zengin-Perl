package Zengin::Perl;
use 5.010;
use strict;
use warnings;

our $VERSION = "0.01";

use Carp qw/croak/;

sub new {
    my $class = shift;

    my $self = bless {}, $class;

    return $self;
}

sub bank {
    my $self = shift;
    my $num  = shift;

    croak "The argument must be a number\n" unless $num =~ /\d+/;

    my $bank_code = sprintf( '%04d', $num );

    my $bank = Bank->new($bank_code);

    my $branches = Branches->new($bank_code);
    $self->branches($branches);

    return $bank;
}

sub branch {
    my $self = shift;
    my $num  = shift;

    croak "The argument must be a number\n" unless $num =~ /\d+/;

    my $branch_code = sprintf( '%03d', $num );

    my $branch = $self->branches->{$branch_code};

    return $branch;
}

sub branches {
    my $self = shift;
    my $argv = shift;

    if ($argv) {
        $self->{branches} = $argv;
    }

    return $self->{branches};
}

sub all_branches {
    my $banks    = Bank->_all_banks();
    my $branches = Branches->_all_branches();

    my $all_branches = [];
    while ( my ( $bank_code, $branch ) = each %{$branches} ) {

        # Exclude closed branches.
        next unless $banks->{$bank_code};

        while ( my ( $branch_code, $branch_info ) = each %{$branch} ) {
            push @{$all_branches}, {
                bank_code => $banks->{$bank_code}->{code},
                bank_name => $banks->{$bank_code}->{name},
                bank_hira => $banks->{$bank_code}->{hira},
                bank_kana => $banks->{$bank_code}->{kana},
                bank_roma => $banks->{$bank_code}->{roma},

                branch_code => $branch_code,
                branch_name => $branch_info->{name},
                branch_hira => $branch_info->{hira},
                branch_kana => $branch_info->{kana},
                branch_roma => $branch_info->{roma},
            };
        }
    }

    return $all_branches;
}

package Branches;
use JSON qw/decode_json/;
use File::Spec;
use constant { BRANCHES_FOLDER => '../source-data/data/branches', };

sub new {
    my $class = shift;
    my $num   = shift;

    my $self = bless _setup_branches($num), $class;

    return $self;
}

sub _all_branches {
    my $folder_path = File::Spec->catfile( BRANCHES_FOLDER, '*.json' );
    my @paths       = glob($folder_path);

    my $branches;
    for my $file_path ( sort @paths ) {

        $file_path =~ /(?<bank_code>\d{4})/;
        my $bank_code = $+{bank_code};

        my $file = File->new($file_path);
        $branches->{$bank_code} = decode_json( $file->read );
    }

    return $branches;

}

sub _setup_branches {
    my $bank_code = shift;

    my $branches_file_path
        = File::Spec->catfile( BRANCHES_FOLDER, "${bank_code}.json" );

    my $file             = File->new($branches_file_path);
    my $branches_hashref = decode_json( $file->read );

    my $branches;
    while ( my ( $code, $info ) = each %{$branches_hashref} ) {
        $branches->{$code} = Branch->new($info);
    }

    if ($branches) {
        return $branches;
    }
    else {
        return {};
    }

}

package Bank;
use constant { BANKS_JSON => '../source-data/data/banks.json', };
use JSON qw/decode_json/;

sub new {
    my $class     = shift;
    my $bank_code = shift;

    my $bank_info = _setup_bank($bank_code);

    my $self = bless $bank_info, $class;

    return $self;
}

sub code {
    my $self = shift;

    return $self->{code};
}

sub name {
    my $self = shift;

    return $self->{name};
}

sub hira {
    my $self = shift;

    return $self->{hira};
}

sub kana {
    my $self = shift;

    return $self->{kana};
}

sub roma {
    my $self = shift;

    return $self->{roma};
}

sub _setup_bank {
    my $bank_code = shift;

    my $banks_json_path = File::Spec->canonpath(BANKS_JSON);

    my $file       = File->new($banks_json_path);
    my $banks_info = decode_json( $file->read );

    my $bank_info = $banks_info->{$bank_code};

    if ( $banks_info->{$bank_code} ) {
        return $bank_info;
    }
    else {
        return {};
    }

}

sub _all_banks {
    my $banks_json_path = File::Spec->canonpath(BANKS_JSON);
    my $data = File->new($banks_json_path);

    my $banks_info = decode_json( $data->read );

    return $banks_info;
}

package Branch;

sub new {
    my $class = shift;

    my $branch_info = shift;

    my $self = bless $branch_info, $class;

    return $self;
}

sub code {
    my $self = shift;

    return $self->{code};
}

sub name {
    my $self = shift;

    return $self->{name};
}

sub hira {
    my $self = shift;

    return $self->{hira};
}

sub kana {
    my $self = shift;

    return $self->{kana};
}

sub roma {
    my $self = shift;

    return $self->{roma};
}

package File;
use Carp qw/croak/;
use File::Spec;

sub new {
    my $class = shift;
    my $file  = shift;
    my $self  = bless { file => File::Spec->canonpath($file) }, $class;
    return $self;
}

sub file {
    my $self = shift;

    return $self->{file};
}

sub read {
    my $self = shift;

    open my $FH, '<', $self->file or croak "READ_ERR:$self->{file}";
    my $data;
    {
        local $/;
        $data = <$FH>;
    }
    close $FH;

    return $data;
}

1;
__END__

=encoding utf-8

=head1 NAME

Zengin::Perl - The perl implementation of ZenginCode.


=head1 SYNOPSIS

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


=head1 DESCRIPTION

The perl implementation of ZenginCode.

ZenginCode is datasets of bank codes and branch codes for japanese.

=head1 LICENSE

Copyright (C) sironekotoro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

sironekotoro E<lt>develop@sironekotoro.comE<gt>

=cut

