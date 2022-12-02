
	if ( $] ge 5.011002 and $] lt 5.021007 ) {
		$meta->{prereqs}{runtime}{recommends}{'Lexical::Var'} = '0';
	}
	elsif ( $] ge 5.018000 and $] lt 5.037002 ) {
		$meta->{prereqs}{runtime}{recommends}{'Alt::Lexical::Var::ButSupportModernPerl'} = '0.001';
	}

	if ( $] lt 5.034 ) {
		$meta->{prereqs}{runtime}{requires}{'Syntax::Keyword::Try'} = '0';
	}
