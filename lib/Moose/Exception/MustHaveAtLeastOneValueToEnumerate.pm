package Moose::Exception::MustHaveAtLeastOneValueToEnumerate;
our $VERSION = '2.1703';

use Moose;
extends 'Moose::Exception';
with 'Moose::Exception::Role::ParamsHash';

has 'class' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

sub _build_message {
    "You must have at least one value to enumerate through";
}

1;
