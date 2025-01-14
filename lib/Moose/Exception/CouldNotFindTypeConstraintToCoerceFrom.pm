package Moose::Exception::CouldNotFindTypeConstraintToCoerceFrom;
our $VERSION = '2.1703';

use Moose;
extends 'Moose::Exception';
with 'Moose::Exception::Role::Instance';

has 'constraint_name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

sub _build_message {
    my $self = shift;
    "Could not find the type constraint (".$self->constraint_name.") to coerce from";
}

1;
