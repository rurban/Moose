package Moose::Exception::MustSupplyArrayRefAsCurriedArguments;
our $VERSION = '2.1703';

use Moose;
extends 'Moose::Exception';
with 'Moose::Exception::Role::ParamsHash', 'Moose::Exception::Role::Class';

sub _build_message {
    "You must supply a curried_arguments which is an ARRAY reference";
}

1;
