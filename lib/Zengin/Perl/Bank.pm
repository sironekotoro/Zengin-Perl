#!/usr/bin/env perl
package Zengin::Perl::Bank;
use Carp;
use JSON qw/decode_json/;
use Moo 2.004004;

use Exporter 'import';
our @EXPORT = qw/branch/;

map { has $_ => ( is => 'ro' ) } qw (code name hira kana roma _path);

has branches => (
    is      => "ro",
    builder => "_branches_builder",
    lazy    => 1,
);

sub _branches_builder {
    my $self = shift;

    my $file;
    open my $FH, '<', $self->_path or die;
    {
        local $/;
        $file = <$FH>;
    }
    close $FH;

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

sub branch {
    my ( $self, %arg ) = @_;
    my $branch_code = $arg{branch_code};

    return $self->branches->{$branch_code};
}

sub branch_name_search {
    my ( $self, %arg ) = @_;
    my $branch_name = $arg{branch_name};

    my @result = ();

    for my $branch_code ( sort keys %{ $self->branches } ) {
        my $branch = $self->branches->{$branch_code};
        push @result, $branch if $branch->name =~ /$branch_name/;
    }

    return \@result;
}

sub branch_code_search {
    my ( $self, %arg ) = @_;
    my $branch_code = $arg{branch_code};

    return $self->branch( branch_code => $branch_code );
}

__PACKAGE__->meta->make_immutable();

1;

=encoding utf-8

=head1 NAME

Zengin::Perl::Bank - Bank class

=head1 METHODS

=head2 branch

=head2 branch_name_search

=head2 branch_code_search

=head1 LICENSE

Copyright (C) sironekotoro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

sironekotoro E<lt>develop@sironekotoro.comE<gt>

=cut

