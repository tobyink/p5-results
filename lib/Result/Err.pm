use 5.014;
use strict;
use warnings;

use Result::Trait ();

package Result::Err;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.003';

use Role::Tiny::With;
with 'Result::Trait';

'overload'->import( 'Result::Trait'->__OVERLOAD_ARGS__( 'err', '_peek_err' ) );

sub new {
	my $class = shift;

	bless [ !!0, [ @_ ] ], $class;
}

sub _handled {
	@_ == 1
		? $_[0][0]
		: ( $_[0][0] = $_[1] );
}

sub _peek {
	die;
}

sub _peek_err {
	my ( $self ) = @_;
	wantarray
		? @{ $self->[1] }
		: $self->[1][-1];
}

sub is_err {
	@_ == 1
		or Carp::croak( 'Usage: $result->is_err()' );

	!!1;
}

sub is_ok {
	@_ == 1
		or Carp::croak('Usage: $result->is_ok()');

	!!0;
}

sub unwrap {
	my ( $self ) = @_;
	@_ == 1
		or Carp::croak( 'Usage: $result->unwrap()' );

	Carp::croak( $self->unwrap_err() );
}

sub unwrap_err {
	my ( $self ) = @_;
	@_ == 1
		or Carp::croak( 'Usage: $result->unwrap_err()' );

	$self->[0] = !!1;

	wantarray
		? @{ $self->[1] }
		: $self->[1][-1];
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Result::Err - a class for error results

=head1 DESCRIPTION

Refer to the C<err> function in L<results> to find out how to construct
instances of this class. Refer to L<Result::Trait> for the API documentation
for objects of this class.

=head1 BUGS

Please report any bugs to
<https://github.com/tobyink/p5-results/issues>.

=head1 SEE ALSO

L<result>, L<Result::Trait>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2022 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
