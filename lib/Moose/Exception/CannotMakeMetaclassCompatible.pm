package Moose::Exception::CannotMakeMetaclassCompatible;
our $VERSION = '2.1703';

use Moose;
extends 'Moose::Exception';
with 'Moose::Exception::Role::Class';

has 'superclass_name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

sub _build_message {
    my $self = shift;
    my $class_name = $self->class_name;
    my $superclass = $self->superclass_name;

    return "Can't make $class_name compatible with metaclass $superclass";
}

1;
