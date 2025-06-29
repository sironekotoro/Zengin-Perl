#!/usr/bin/env perl
package Zengin::Perl;
use 5.014;
use Carp;
use File::Share 0.25 qw/dist_file dist_dir/;
use File::Spec;
use JSON qw/decode_json/;
use Moo 2.004004;

use FindBin;
use lib "$FindBin::Bin/lib";
use parent qw/
  Zengin::Perl::Bank
  Zengin::Perl::Branch
  /;

our $VERSION = "0.12.20250629";

has banks_file => (
    is      => "ro",
    builder => "_banks_file_builder",
    lazy    => 1,
);

has branches_folder => (
    is      => "ro",
    builder => "_branches_folder_builder",
    lazy    => 1,
);

has banks => (
    is      => "ro",
    builder => "_banks_builder",
    lazy    => 1,
);

sub last_update {
    my ( undef, undef, $last_update ) = split /\./, $VERSION;

    return $last_update;
}

sub _banks_file_builder {

    return dist_file( 'Zengin-Perl', 'data/banks.json' );
}

sub _branches_folder_builder {
    my $dir = dist_dir('Zengin-Perl');

    return File::Spec->catfile( $dir, 'data', 'branches' );
}

sub _banks_builder {
    my $self = shift;

    my $file;
    open my $FH, '<', $self->banks_file or die;
    {
        local $/;
        $file = <$FH>;
    }
    close $FH;

    my $banks = decode_json($file);

    my %banks = do {
        my %hash = ();
        while ( my ( $key, $value ) = each %{$banks} ) {
            $hash{$key} = Zengin::Perl::Bank->new($value);

            $hash{$key}{_path} = File::Spec->catfile( $self->branches_folder,
                $value->{code} . '.json' );
        }
        %hash;
    };

    return \%banks;
}

sub bank {
    my ( $self, %arg ) = @_;

    my $bank_code = $arg{bank_code};

    return $self->banks->{$bank_code};
}

sub bank_name_search {
    my ( $self, %arg ) = @_;

    my $bank_name = $arg{bank_name};

    my $banks  = $self->banks();
    my @result = ();

    for my $code ( sort keys %{$banks} ) {
        my $bank = $banks->{$code};
        push @result, $bank
          if $bank->name() =~ /$bank_name/;
    }

    return \@result;
}

sub bank_code_search {
    my ( $self, %arg ) = @_;

    my $bank_code = $arg{bank_code};
    return $self->bank( bank_code => $bank_code );
}

__PACKAGE__->meta->make_immutable();

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
    my $bank = $zp->bank( bank_code => '0001' );
    print $bank->code() . "\n";    # 0001
    print $bank->name() . "\n";    # みずほ
    print $bank->hira() . "\n";    # みずほ
    print $bank->kana() . "\n";    # ミズホ
    print $bank->roma() . "\n";    # mizuho

    # banks
    my $banks = $zp->banks();
    while ( my ( $bank_code, $bank_info ) = each %{$banks} ) {
        print "=" x 20 . "\n";
        print $bank_info->code . "\n";
        print $bank_info->roma . "\n";
        print "=" x 20 . "\n";
    }

    # branch info
    $bank = $zp->bank( bank_code => '0001' );
    my $branch = $bank->branch( branch_code => '001' );
    print $branch->code() . "\n";    # 001
    print $branch->name() . "\n";    # 東京営業部
    print $branch->hira() . "\n";    # とうきよう
    print $branch->kana() . "\n";    # トウキヨウ
    print $branch->roma() . "\n";    # toukiyou

    # branch list
    $bank = $zp->bank( bank_code => '0001' );
    my $branches = $bank->branches();
    while ( my ( $branch_code, $branch_info ) = each %{$branches} ) {
        print $branch_code , ':', $branch_info->roma . "\n";
    }

=head1 DESCRIPTION

The perl implementation of ZenginCode.

ZenginCode is Datasets of bank codes and branch codes for japanese.

=head1 METHODS

=head2 bank

    my $bank = $zp->bank(bank_code => '0001');

    return Bank object. bank_code is Required.

=head2 banks

    my $bank = $zp->banks();

    return HashRef. key is bank_code, value is Bank object.

=head2 branch

    my $bank   = $zp->bank(bank_code => '0001');
    my $branch = $bank->branch( branch_code => '001' );

    return HashRef. key is branch_code, value is Branch object.


=head2 branches

=head2 bank_name_search

=head2 bank_code_search

=head2 last_update

=head1 LICENSE

Copyright (C) sironekotoro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

sironekotoro E<lt>develop@sironekotoro.comE<gt>

=cut

