package Moose::Exception::CallingMethodOnAnImmutableInstance;
our $VERSION = '2.1703';

use Moose;
extends 'Moose::Exception';

has 'method_name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

sub _build_message {
    my $self = shift;
    "The '".$self->method_name."' method cannot be called on an immutable instance";
}

1;
