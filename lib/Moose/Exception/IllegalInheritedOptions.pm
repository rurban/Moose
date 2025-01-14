package Moose::Exception::IllegalInheritedOptions;
our $VERSION = '2.1703';

use Moose;
extends 'Moose::Exception';
with 'Moose::Exception::Role::ParamsHash';

has 'illegal_options' => (
    is       => 'ro',
    traits   => ['Array'],
    handles  => {
        _join_options => 'join',
    },
    required => 1,
);

sub _build_message {
    my $self = shift;
    "Illegal inherited options => (".$self->_join_options(', ').")";
}

1;
