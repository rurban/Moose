package Moose::Exception::UndefinedHashKeysPassedToMethod;
our $VERSION = '2.1703';

use Moose;
extends 'Moose::Exception';

has 'hash_keys' => (
    is         => 'ro',
    isa        => 'ArrayRef',
    required   => 1
);

has 'method_name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

sub _build_message {
    my $self = shift;
    "Hash keys passed to ".$self->method_name." must be defined";
}

1;
