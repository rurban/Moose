package Moose::Exception::OverloadRequiresAMetaClass;
our $VERSION = '2.1703';

use Moose;
extends 'Moose::Exception';

sub _build_message {
    my $self = shift;
    'If you provide an associated_metaclass parameter to the Moose::Meta::Overload constructor it must be a Class::MOP::Module object';
}

1;
