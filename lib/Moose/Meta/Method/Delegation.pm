package Moose::Meta::Method::Delegation;

use strict;
use warnings;

use Scalar::Util 'blessed', 'weaken';

use parent 'Moose::Meta::Method',
         'Class::MOP::Method::Generated';

use Moose::Util 'throw_exception';

sub new {
    my $class   = shift;
    my %options = @_;

    ( exists $options{attribute} )
        || throw_exception( MustSupplyAnAttributeToConstructWith => params => \%options,
                                                                    class  => $class
                          );

    ( blessed( $options{attribute} )
            && $options{attribute}->isa('Moose::Meta::Attribute') )
        || throw_exception( MustSupplyAMooseMetaAttributeInstance => params => \%options,
                                                                     class  => $class
                          );

    ( $options{package_name} && $options{name} )
        || throw_exception( MustSupplyPackageNameAndName => params => \%options,
                                                            class  => $class
                          );

    ( $options{delegate_to_method} && ( !ref $options{delegate_to_method} )
            || ( 'CODE' eq ref $options{delegate_to_method} ) )
        || throw_exception( MustSupplyADelegateToMethod => params => \%options,
                                                           class  => $class
                          );

    exists $options{curried_arguments}
        || ( $options{curried_arguments} = [] );

    ( $options{curried_arguments} &&
        ( 'ARRAY' eq ref $options{curried_arguments} ) )
        || throw_exception( MustSupplyArrayRefAsCurriedArguments => params     => \%options,
                                                                    class_name => $class
                          );

    my $self = $class->_new( \%options );

    weaken( $self->{'attribute'} );

    $self->_initialize_body;

    return $self;
}

sub _new {
    my $class = shift;
    my $options = @_ == 1 ? $_[0] : {@_};

    return bless $options, $class;
}

sub curried_arguments { (shift)->{'curried_arguments'} }

sub associated_attribute { (shift)->{'attribute'} }

sub delegate_to_method { (shift)->{'delegate_to_method'} }

sub _initialize_body {
    my $self = shift;

    $self->{body} = $self->_generate_inline_method;
}

sub _generate_inline_method {
    my $self = shift;

    my $attr = $self->associated_attribute;
    # If the delegation isn't to a coderef then inlining the method name
    # should be faster (I think).
    my $call
        = ref $self->delegate_to_method
        ? '$method_to_call'
        : $self->delegate_to_method;

    $call .=
        @{ $self->curried_arguments }
        ? '(@curried, @_)'
        : '(@_)';

    my @source = (
        'sub {',
            'my $proxy = ' . $attr->_inline_instance_get('$_[0]') . ';',
            'if ( !defined $proxy ) {',
                $self->_inline_throw_exception(
                    'AttributeValueIsNotDefined',
                    'method    => $_[0]->meta->find_method_by_name(' . B::perlstring( $self->name ) . '),' .
                    'instance  => $_[0],' .
                    'attribute => $_[0]->meta->find_attribute_by_name('. B::perlstring(
                        $self->associated_attribute->name
                        ) . ')',
                    ) . ';',
            '} elsif( ref($proxy) && !Scalar::Util::blessed($proxy) ) {',
                $self->_inline_throw_exception(
                    'AttributeValueIsNotAnObject',
                    'method    => $_[0]->meta->find_method_by_name(' . B::perlstring( $self->name ) . '),' .
                    'instance  => $_[0],' .
                    'attribute => $_[0]->meta->find_attribute_by_name('. B::perlstring(
                        $self->associated_attribute->name
                        ) . '),' .
                    'given_value => $proxy',
                    ) . ';',
            '}',
            'return $proxy->' . $call . ';',
        '}',
    );

    return try {
        $self->_compile_code(
            source      => \@source,
            description => 'inline delegation for '
                . $self->associated_attribute->name . '->'
                . $call,
        );
    }
    catch {
        $self->_throw_exception(
            'CouldNotGenerateInlineAttributeMethod',
            instance => $self,
            error    => $_,
            option   => 'handles',
        );
    };
}

sub _eval_environment {
    my $self = shift;

    my %env;
    $env{'@curried'} = $self->curried_arguments
        if @{ $self->curried_arguments };

    $env{'$method_to_call'} = $self->delegate_to_method
        if ref $self->delegate_to_method;

    return \%env;
}

1;

# ABSTRACT: A Moose Method metaclass for delegation methods

__END__

=pod

=head1 DESCRIPTION

This is a subclass of L<Moose::Meta::Method> for delegation
methods.

=head1 METHODS

=over 4

=item B<< Moose::Meta::Method::Delegation->new(%options) >>

This creates the delegation methods based on the provided C<%options>.

=over 4

=item I<attribute>

This must be an instance of C<Moose::Meta::Attribute> which this
accessor is being generated for. This options is B<required>.

=item I<delegate_to_method>

The method in the associated attribute's value to which we
delegate. This can be either a method name or a code reference.

=item I<curried_arguments>

An array reference of arguments that will be prepended to the argument list for
any call to the delegating method.

=back

=item B<< $metamethod->associated_attribute >>

Returns the attribute associated with this method.

=item B<< $metamethod->curried_arguments >>

Return any curried arguments that will be passed to the delegated method.

=item B<< $metamethod->delegate_to_method >>

Returns the method to which this method delegates, as passed to the
constructor.

=back

=head1 BUGS

See L<Moose/BUGS> for details on reporting bugs.

=cut
