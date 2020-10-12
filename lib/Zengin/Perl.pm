use 5.014;

package Zengin::Perl {
    use Carp 1.50 qw/croak/;
    use File::Share 0.25 ':all';
    use File::Spec 3.74;
    use JSON 4.01 qw/decode_json/;
    use Mouse v2.5.10;

    our $VERSION = "0.09";

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

    has banks => (
        is      => "ro",
        isa     => "HashRef",
        builder => "_banks_builder",
        lazy    => 1,
    );

    sub _banks_file_builder {
        my $self = shift;
        return dist_file( 'Zengin-Perl', 'data/banks.json' );
    }

    sub _branches_folder_builder {
        my $self = shift;
        my $dir  = dist_dir('Zengin-Perl');
        return File::Spec->catfile( $dir, 'data', 'branches' );
    }

    sub bank {
        my $self = shift;
        my %arg  = @_;

        my $bank_code = sprintf( '%04d', $arg{bank_code} );

        croak "The argument must be a number.\n"
            unless $bank_code =~ /\d+/;

        croak "There is no corresponding bank code.\n"
            unless exists $self->banks->{$bank_code};

        return $self->banks->{$bank_code};
    }

    sub _banks_builder {
        my $self = shift;

        my $data  = File->new( file => $self->banks_file );
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

    sub search {
        my $self = shift;
        my @argv = @_;

        my @result;
        my $banks = $self->banks();

        for my $code ( sort keys %{$banks} ) {
            my $bank = $banks->{$code};
            push @result, $bank
                if $bank->name() =~ /$argv[0]/;
        }

        return \@result;
    }

    __PACKAGE__->meta->make_immutable();

}

package Bank {
    use Carp 1.50 qw/croak/;
    use JSON 4.01 qw/decode_json/;
    use Mouse v2.5.10;

    has code => (
        is  => "ro",
        isa => "Int",
    );

    map { has $_ => ( is => 'ro', isa => 'Str' ) }
        qw (name hira kana roma _path);

    sub branch {
        my $self = shift;
        my %arg  = @_;

        my $branch_code = sprintf( '%03d', $arg{branch_code} );

        croak "The argument must be a number.\n"
            unless $arg{branch_code} =~ /\d+/;

        croak "There is no corresponding branch code.\n"
            unless exists $self->branches->{$branch_code};

        return $self->branches->{$branch_code};

    }

    has branches => (
        is      => "ro",
        builder => "_branches_builder",
        lazy    => 1,
    );

    sub _branches_builder {
        my $self = shift;

        my $data  = File->new( file => $self->_path );
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
    use Mouse v2.5.10;

    has code => (
        is  => "ro",
        isa => "Int",
    );

    map { has $_ => ( is => 'ro', isa => 'Str' ) } qw (name hira kana roma);

    __PACKAGE__->meta->make_immutable();
}

package File {
    use Carp 1.50 qw/croak/;
    use File::Spec 3.74;
    use Mouse v2.5.10;

    has file => (
        is  => "ro",
        isa => "Str",
    );

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
    __PACKAGE__->meta->make_immutable();
};

1;
__END__

=encoding utf-8

=head1 NAME

Zengin::Perl - The perl implementation of ZenginCode.

=head1 INSTALLATION

    cpanm git@github.com:sironekotoro/Zengin-Perl.git

=head1 SYNOPSIS

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

=head1 DESCRIPTION

The perl implementation of ZenginCode.

ZenginCode is Datasets of bank codes and branch codes for japanese.

=head1 METHODS

=head2 bank

=head2 banks

=head2 branch

=head2 branches

=head2 search

=head1 LICENSE

Copyright (C) sironekotoro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

sironekotoro E<lt>develop@sironekotoro.comE<gt>

=cut

