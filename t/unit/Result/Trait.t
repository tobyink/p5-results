=pod

=encoding utf-8

=head1 PURPOSE

Unit tests for L<Result::Trait>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2022 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

use Test2::V0 -target => 'Result::Trait';
use Test2::Tools::Spec;
use Data::Dumper;

use results ();

describe "method `and`" => sub {

	tests 'examples from Rust documentation' => sub {

		{
			my $x = results::ok( 2 );
			my $y = results::err( "late error" );
			is( $x->and( $y )->unwrap_err(), "late error" );
		}

		{
			my $x = results::err( "early error" );
			my $y = results::ok( "foo" );
			is( $x->and( $y )->unwrap_err(), "early error" );
			$y->unwrap();
		}

		{
			my $x = results::err( "not a 2" );
			my $y = results::err( "late error" );
			is( $x->and( $y )->unwrap_err(), "not a 2" );
			$y->unwrap_err();
		}

		{
			my $x = results::ok( 2 );
			my $y = results::ok( "different result type" );
			is( $x->and( $y )->unwrap(), "different result type" );
		}
	};
};

describe "method `and_then`" => sub {

	tests 'examples from Rust documentation' => sub {

		my $square = sub {
			my ( $x ) = @_;
			return results::err( "not a number" )
				unless $x =~ /^[0-9]+(\.[0-9]+)?/;
			return results::ok( $x * $x );
		};

		is( results::ok( 2 )->and_then( $square )->unwrap(), 4 );
		is( results::ok( "ok" )->and_then( $square )->unwrap_err(), "not a number" );
		is( results::err( "err" )->and_then( $square )->unwrap_err(), "err" );
	};
};

describe "method `err`" => sub {

	tests 'examples from Rust documentation' => sub {

		{
			my $x = results::ok( 2 );
			is( $x->err(), undef );
		}

		{
			my $x = results::err( "nothing here" );
			is( $x->err(), "nothing here" );
		}
	};
};

describe "method `expect`" => sub {

	tests 'examples from Rust documentation' => sub {

		my $x = results::err( "emergency failure" );
		my $e = dies {
			$x->expect( "Testing expect" );
		};
		like $e, qr/Testing expect/;
	};
	
	tests 'further tests' => sub {
		my $x = results::ok( 42 );
		is( $x->expect( "Testing expect" ), 42 );
	};
};

describe "method `expect_err`" => sub {

	tests 'examples from Rust documentation' => sub {

		my $x = results::ok( 10 );
		my $e = dies {
			$x->expect_err( "Testing expect_err" );
		};
		like $e, qr/Testing expect_err/;
	};
	
	tests 'further tests' => sub {
		my $x = results::err( "emergency failure" );
		is( $x->expect_err( "Testing expect_err" ), "emergency failure" );
	};
};

done_testing;
