package Zengin::Perl {
    use 5.014;
    use Mouse;

    our $VERSION = "0.07";

    use Carp 1.50 qw/croak/;
    use JSON 4.01 qw/decode_json/;

    has source_data_path => (
        is       => "ro",
        isa      => "Str",
        required => 1,
    );

    has banks_file => (
        is      => "ro",
        isa     => "Str",
        builder => "_banks_file_builder",
        lazy    => 1,
    );

    has branches_folder => (
        is      => "ro",
        isa     => "Str",
        builder => "_branches_folder_builder",
        lazy    => 1,
    );

    has bank_code => (
        is  => "rw",
        isa => "Str",
    );

    has branches => (
        is      => "ro",
        builder => "_branches_builder",
        lazy    => 1,
    );

    has banks => (
        is      => "ro",
        isa     => "HashRef",
        builder => "_banks_builder",
        lazy    => 1,
    );

    sub _banks_file_builder {
        my $self = shift;
        File::Spec->catfile( $self->source_data_path, 'data', 'banks.json' );
    }

    sub _branches_folder_builder {
        my $self = shift;
        File::Spec->catfile( $self->source_data_path, 'data', 'branches' );
    }

    sub bank {
        my $self = shift;

        my %arg = @_;

        croak "The argument must be a number\n"
            unless $arg{bank_code} =~ /\d+/;

        my $bank_code = sprintf( '%04d', $arg{bank_code} );
        $self->bank_code($bank_code);

        return $self->banks->{$bank_code};
    }

    sub _branches_builder {
        my $self = shift;

        return Branches->new(
            {   bank_code       => $self->bank_code,
                branches_folder => $self->branches_folder
            }
        );
    }

    sub _banks_builder {
        my $self = shift;

        my $data  = File->new( $self->banks_file );
        my $banks = decode_json( $data->read );

        my %banks = do {
            my %hash = ();
            while ( my ( $key, $value ) = each %{$banks} ) {
                $hash{$key} = Bank->new($value);

                $hash{$key}{_path}
                    = File::Spec->catfile( $self->branches_folder,
                    $value->{code} . '.json' );
            }
            %hash;
        };
        return \%banks;
    }

    sub branch {
        my $self = shift;
        my $num  = shift;

        croak "The argument must be a number\n" unless $num =~ /\d+/;

        my $branch_code = sprintf( '%03d', $num );

        my $branch = $self->branches->{$branch_code};

        return $branch;
    }

    sub all_branches {
        my $self = shift;

        my $data  = File->new( $self->banks_file );
        my $banks = decode_json( $data->read );

        my $branches
            = Branches->_all_branches(
            { branches_folder => $self->branches_folder } );

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

}

package Branches;
use JSON 4.01 qw/decode_json/;
use File::Spec 3.74;

sub new {
    my $class = shift;
    my $argv  = shift;

    my $branches = _setup_branches(
        {   bank_code       => $argv->{bank_code},
            branches_folder => $argv->{branches_folder},
        }
    );

    my $self = bless $branches, $class;

    return $self;
}

sub _all_branches {
    my $self = shift;
    my $argv = shift;

    my $branches_folder_path
        = File::Spec->catfile( $argv->{branches_folder}, '*.json' );
    my @paths = glob($branches_folder_path);

    my $regex_4digit = qr/(?<bank_code>\d{4})/;

    my $branches;
    for my $file_path ( sort @paths ) {
        my $file = File->new($file_path);

        $file_path =~ /$regex_4digit/;

        $branches->{ $+{bank_code} } = decode_json( $file->read );

    }

    return $branches;

}

sub _setup_branches {
    my $argv = shift;

    my $branches_file_path = File::Spec->catfile( $argv->{branches_folder},
        "$argv->{bank_code}.json" );

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

package Bank {
    use Carp 1.50 qw/croak/;
    use JSON 4.01 qw/decode_json/;
    use Mouse 2.5.10;

    has code => (
        is  => "ro",
        isa => "Int",
    );

    map { has $_ => ( is => 'ro', isa => 'Str' ) } qw (name hira kana roma);

    # has branch => (
    #     is      => "rw",
    #     builder => "_branch_builder",
    #     lazy    => 1,
    # );

    sub branch {
        my $self = shift;
        my %arg  = @_;

        croak "The argument must be a number\n"
            unless $arg{branch_code} =~ /\d+/;

        my $branch_code = sprintf( '%03d', $arg{branch_code} );

        return $self->branches->{$branch_code};

    }

    has branches => (
        is      => "ro",
        builder => "_branches_builder",
        lazy    => 1,
    );

    sub _branches_builder {
        my $self = shift;

        my $data  = File->new( $self->{_path} );
        my $banks = decode_json( $data->read );

        my %branches = do {
            my %hash = ();
            while ( my ( $key, $value ) = each %{$banks} ) {
                $hash{$key} = Branch->new($value);
            }
            %hash;
        };
        return \%branches;
    }

    __PACKAGE__->meta->make_immutable();
}

package Branch {
    use Mouse 2.5.10;

    has code => (
        is  => "ro",
        isa => "Int",
    );

    map { has $_ => ( is => 'ro', isa => 'Str' ) } qw (name hira kana roma);

    __PACKAGE__->meta->make_immutable();
}

package File;
use Carp 1.50 qw/croak/;
use File::Spec 3.74;

sub new {
    my $class = shift;
    my $file  = shift;

    my $self = bless { file => File::Spec->canonpath($file) }, $class;

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

    # Prepare the source-data in advance.
    # source-data : https://github.com/zengin-code/source-data

    my $zp = Zengin::Perl->new({
        source_data_path => '/Users/sironekotoro/Desktop/source-data'
    });

    # bank info
    my $bank = $zp->bank( bank_code => 0001 );
    print $bank->code() . "\n"; # 0001
    print $bank->name() . "\n"; # みずほ
    print $bank->hira() . "\n"; # みずほ
    print $bank->kana() . "\n"; # ミズホ
    print $bank->roma() . "\n"; # mizuho

    # banks
    my $banks = $zp->banks();
    while ( my ( $bank_code, $bank_info ) = each %{$banks} ) {
        print "=" x 20 . "\n";
        print $bank_info->{code} . "\n";
        print $bank_info->{roma} . "\n";
        print "=" x 20 . "\n";
    }

    # branch info
    my $branch = $zp->branch(1);
    print $branch->code() . "\n"; # 001
    print $branch->name() . "\n"; # 東京営業部
    print $branch->hira() . "\n"; # とうきよう
    print $branch->kana() . "\n"; # トウキヨウ
    print $branch->roma() . "\n"; # toukiyou


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

ZenginCode is Datasets of bank codes and branch codes for japanese.

=head1 LICENSE

Copyright (C) sironekotoro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

sironekotoro E<lt>develop@sironekotoro.comE<gt>

=cut

