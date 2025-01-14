package Moose::Exception::BuilderMustBeAMethodName;
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
    "builder must be a defined scalar value which is a method name";
}

1;
