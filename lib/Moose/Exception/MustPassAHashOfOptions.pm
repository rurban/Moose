package Moose::Exception::MustPassAHashOfOptions;
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
    "You must pass a hash of options";
}

1;
