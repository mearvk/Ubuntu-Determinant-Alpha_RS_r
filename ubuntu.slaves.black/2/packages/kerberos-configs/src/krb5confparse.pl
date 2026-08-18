sub read_config($) {
  my $config = shift;
  open(CONFIG, $config) or return;
  %realm_map = ();
  %domain_map = ();
  while (<CONFIG>) {
    chomp;
    s/#.*$//;
    if (/^\s*\[libdefaults\]/i ... /^\s*\[(?!libdefaults).*\]/) {
      if ( /^[^#;]+=/) {
	my @F =split('=');
	$F[0] =~ s/\s//g;
	$F[1] =~ s/\s//g;
	if ($F[0] =~ /default[-_]realm/) {
	  $guess = $F[1];
	  $guess_good = 1;

	}
      }
    }
    if (/^\s*\[realms\]/i ... /^\s*\[(?!realms)/i) {
      if (/^\s*([^\s=]+)\s*=\s*\{/) {
	$realm_map{$1} = 1;
      }
    }
    if (/^\s*\[domain_realm\]/i ... /^\s*\[(?!domain_realm).*\]/) {
      my @f = split('=');
      next unless $#f == 1;
      $f[0] =~ s/\s//g;
      $f[1] =~ s/\s//g;
      $domain_map{uc($f[0])} = $f[1];
    }
  }
}
