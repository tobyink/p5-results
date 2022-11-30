=pod

=encoding utf-8

=head1 PURPOSE

Unit tests for L<Result::Ok>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2022 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

use Test2::V0 -target => 'Result::Ok';
use Test2::Tools::Spec;
use Data::Dumper;

use results ();

describe "class `$CLASS`" => sub {

	tests 'objects can be constructed' => sub {
	
		my $r = $CLASS->new();
		ok( $r->isa( $CLASS ), "isa $CLASS" );
		ok( $r->DOES( 'Result::Trait' ), "DOES Result::Trait" );
		
		$r->unwrap(); # avoid warning
	};
};

describe "method `_handled`" => sub {

	tests 'method works' => sub {
	
		my $r = $CLASS->new();
		ok( !$r->_handled, "false to start with" );
		$r->_handled( !!1 );
		ok( $r->_handled, "can be set to true" );
		$r->_handled( !!0 );
		ok( !$r->_handled, "can be set to false" );
		
		$r->unwrap(); # avoid warning
	};
};

describe "method `_peek`" => sub {

	tests 'method works' => sub {
	
		my $r = $CLASS->new( 5 .. 10 );
		is( scalar($r->_peek), 10, "in scalar context" );
		is( [$r->_peek], [5..10], "in list context" );
		is( do { $r->_peek; 1 }, 1, "in void context (doesn't throw)" );
		
		$r->unwrap(); # avoid warning
	};
};

describe "method `is_err`" => sub {

	tests 'method works' => sub {
	
		my $r = $CLASS->new();
		ok( !$r->is_err, 'is false' );
		
		$r->unwrap(); # avoid warning
	};
};

describe "method `is_ok`" => sub {

	tests 'method works' => sub {
	
		my $r = $CLASS->new();
		ok( $r->is_ok, 'is true' );
		
		$r->unwrap(); # avoid warning
	};
};

describe "method `unwrap`" => sub {

	tests 'method works' => sub {
	
		my $r = $CLASS->new( 5 .. 10 );
		is( scalar($r->unwrap), 10, "in scalar context" );
		is( [$r->unwrap], [5..10], "in list context" );
		is( do { $r->unwrap; 1 }, 1, "in void context (doesn't throw)" );
	};
};

describe "method `unwrap_err`" => sub {

	tests 'method throws' => sub {
	
		my $r = $CLASS->new( 5 .. 10 );
		
		{
			my $e = dies {
				my $x = $r->unwrap_err;
			};
			like(
				$e,
				qr/Expected to unwrap Err, but this result is Ok/,
				'exception in scalar context',
			);
		}
		
		{
			my $e = dies {
				my @x = $r->unwrap_err;
			};
			like(
				$e,
				qr/Expected to unwrap Err, but this result is Ok/,
				'exception in list context',
			);
		}
		
		{
			my $e = dies {
				$r->unwrap_err; 1;
			};
			like(
				$e,
				qr/Expected to unwrap Err, but this result is Ok/,
				'exception in void context',
			);
		}
	};
};

done_testing;
