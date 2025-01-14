package Moose::Meta::Method::Accessor::Native::Hash::clear;
our $VERSION = '2.1703';

use strict;
use warnings;

use Moose::Role;

with 'Moose::Meta::Method::Accessor::Native::Hash::Writer';

sub _maximum_arguments { 0 }

sub _adds_members { 0 }

sub _potential_value { '{}' }

sub _inline_optimized_set_new_value {
    my $self = shift;
    my ($inv, $new, $slot_access) = @_;

    return $slot_access . ' = {};';
}

sub _return_value { '' }

no Moose::Role;

1;
