#!/usr/bin/env perl
package Zengin::Perl::Bank;
use Carp;
use File::Slurp 9999.32 qw/read_file/;
use JSON qw/decode_json/;
use Moo 2.004004;

use Exporter 'import';
our @EXPORT = qw/branch/;

has code => ( is => "ro", );

map { has $_ => ( is => 'ro' ) } qw (name hira kana roma _path);

sub branch {
    my ( $self, undef, $branch_code ) = @_;

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

    my $file     = read_file( $self->_path );
    my $branches = decode_json($file);

    my %branches = do {
        my %hash = ();
        while ( my ( $key, $value ) = each %{$branches} ) {
            $hash{$key} = Zengin::Perl::Branch->new($value);
        }
        %hash;
    };
    return \%branches;
}

__PACKAGE__->meta->make_immutable();

1;

=encoding utf-8

=head1 NAME

Zengin::Perl::Bank - Bank class

=head1 METHODS

=head2 branch

=head1 LICENSE

Copyright (C) sironekotoro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

sironekotoro E<lt>develop@sironekotoro.comE<gt>

=cut

