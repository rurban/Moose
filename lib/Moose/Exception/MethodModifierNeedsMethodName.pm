package Moose::Exception::MethodModifierNeedsMethodName;
our $VERSION = '2.1703';

use Moose;
extends 'Moose::Exception';
with 'Moose::Exception::Role::Class';

sub _build_message {
    "You must pass in a method name";
}

1;
