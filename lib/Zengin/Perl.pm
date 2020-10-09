package Zengin::Perl {
    use 5.014;
    use Carp 1.50 qw/croak/;
    use File::Share 0.25 ':all';
    use JSON 4.01 qw/decode_json/;
    use Mouse;

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

    has bank_code => (
        is  => "rw",
        isa => "Str",
    );

    has banks => (
        is      => "ro",
        isa     => "HashRef",
        builder => "_banks_builder",
        lazy    => 1,
    );

    sub _banks_file_builder {
        my $self = shift;
        return dist_file( 'Zengin::Perl', 'data/banks.json' );

    }

    sub _branches_folder_builder {
        my $self = shift;
        my $dir  = dist_dir('Zengin::Perl');
        return File::Spec->catfile( $dir, 'data', 'branches' );
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

    __PACKAGE__->meta->make_immutable();

}

package Bank {
    use Carp 1.50 qw/croak/;
    use JSON 4.01 qw/decode_json/;
    use Mouse;

    has code => (
        is  => "ro",
        isa => "Int",
    );

    map { has $_ => ( is => 'ro', isa => 'Str' ) }
        qw (name hira kana roma _path);

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
    use Mouse;

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
    use Mouse;

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

=head1 LICENSE

Copyright (C) sironekotoro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

sironekotoro E<lt>develop@sironekotoro.comE<gt>

=cut

