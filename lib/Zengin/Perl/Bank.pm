#!/usr/bin/env perl
package Zengin::Perl::Bank;
use Carp;
use File::Slurp 9999.32 qw/read_file/;
use JSON qw/decode_json/;
use Moo 2.004004;
use Function::Parameters 2.001003;

use Exporter 'import';
our @EXPORT = qw/branch/;

map { has $_ => ( is => 'ro' ) } qw (code name hira kana roma _path);

has branches => (
    is      => "ro",
    builder => "_branches_builder",
    lazy    => 1,
);

method _branches_builder() {
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

method branch(:$branch_code) {
    return $self->branches->{$branch_code};
}

method branch_name_search(:$branch_name) {
    my @result = ();

    for my $branch_code (sort keys %{$self->branches}){
        my $branch = $self->branches->{$branch_code};
        push @result, $branch if $branch->name =~ /$branch_name/;
    }

    return \@result;
}

method branch_code_search(:$branch_code) {

    return $self->branch(branch_code => $branch_code);
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

