#!/usr/bin/env perl
package Zengin::Perl::Branch;
use strict;
use warnings;
use Moo 2.004004;

map { has $_ => ( is => 'ro' ) } qw (code name hira kana roma);

__PACKAGE__->meta->make_immutable();

1;

=encoding utf-8

=head1 NAME

Zengin::Perl::Branch - Branch class

=head1 LICENSE

Copyright (C) sironekotoro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

sironekotoro E<lt>develop@sironekotoro.comE<gt>

=cut

