package Moose::Exception::CannotAssignValueToReadOnlyAccessor;
our $VERSION = '2.1703';

use Moose;
extends 'Moose::Exception';
with 'Moose::Exception::Role::Class', 'Moose::Exception::Role::EitherAttributeOrAttributeName';

has 'value' => (
    is       => 'ro',
    isa      => 'Any',
    required => 1
);

sub _build_message {
    my $self = shift;
    "Cannot assign a value to a read-only accessor";
}

1;
