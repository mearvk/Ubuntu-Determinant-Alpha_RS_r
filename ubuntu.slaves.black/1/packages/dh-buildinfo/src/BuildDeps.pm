package BuildDeps;

# This function checks the build dependencies passed in as the first
# parameter. If they are satisfied, returns false. If they are unsatisfied,
# an list of the unsatisfied depends is returned.
#
# Additional parameters that must be passed:
# * A reference to a hash of all "ok installed" the packages on the system,
#   with the hash key being the package name, and the value being the 
#   installed version.
# * A reference to a hash, where the keys are package names, and the
#   value is a true value iff some package installed on the system provides
#   that package (all installed packages provide themselves)
#
# Optionally, the architecture the package is to be built for can be passed
# in as the 4th parameter. If not set, dpkg will be queried for the build
# architecture.
sub depends {
	return check_line(1, @_);
}

# This function is exactly like unmet_build_depends, except it
# checks for build conflicts, and returns a list of the packages
# that are installed and are conflicted with.
sub conflicts {
	return check_line(0, @_);
}

# This function does all the work. The first parameter is 1 to check build
# deps, and 0 to check build conflicts.
sub check_line {
	my $build_depends=shift;
	my $line=shift;
	my %version=%{shift()};
	my %providers=%{shift()};
	my $dump_met=shift();
	my $build_arch=shift || `dpkg --print-architecture`;
	chomp $build_arch;

	my @unmet=();
	my @met=();
	foreach my $dep (split(/,\s*/, $line)) {
		my $ok=0;
		my @possibles=();
		my @effectives=();
ALTERNATE:	foreach my $alternate (split(/\s*\|\s*/, $dep)) {
			my ($package, $rest)=split(/\s*(?=[\[\(])/, $alternate, 2);
			$package =~ s/\s*$//;

			# Check arch specifications.
			if (defined $rest && $rest=~m/\[(.*?)\]/) {
				my $arches=lc($1);
				my $seen_arch='';
				foreach my $arch (split(' ', $arches)) {
					if ($arch eq $build_arch) {
						$seen_arch=1;
						next;
					}
					elsif ($arch eq "!$build_arch") {
						next ALTERNATE;
					}
					elsif ($arch =~ /!/) {
						# This is equivilant to
						# having seen the current arch,
						# unless the current arch
						# is also listed..
						$seen_arch=1;
					}
				}
				if (! $seen_arch) {
					next;
				}
			}
			
			# This is a possible way to meet the dependency.
			# Remove the arch stuff from $alternate.
			$alternate=~s/\s+\[.*?\]//;
			push @possibles, $alternate;
	
			# Check version.
			if (defined $rest && $rest=~m/\(\s*([<>=]{1,2})\s*(.*?)\s*\)/) {
				my $relation=$1;
				my $version=$2;
				
				if (! exists $version{$package}) {
					# Not installed at all, so fail.
					next;
				}
				else {
					# Compare installed and needed
					# version number.
					system("dpkg", "--compare-versions",
						$version{$package}, $relation,
						 $version);
					if (($? >> 8) != 0) {
						next; # fail
					}
				}
			}
			elsif (! defined $providers{$package}) {
				# It's not a versioned dependency, and
				# nothing provides it, so fail.
				next;
			}
	
			# If we get to here, the dependency was met.
			$ok=1;

			if ($dump_met) {
				# keep it
#				push (@effectives, @{$providers{$package}});
				push (@effectives, $package);
			}
		}
	
		if (@possibles && (($build_depends && ! $ok) ||
		                   (! $build_depends && $ok))) {
			# TODO: this could return a more complex
			# data structure instead to save re-parsing.
			push @unmet, join (" | ", @possibles);
		} else {
			push @met, @effectives;
		}
	}

	if ($dump_met) {
	  return @met;
	} else {
	  return @unmet;
	}
}

sub pkginfo {
  my $package = shift;
  my %version=%{shift()};
  my %providers=%{shift()};

  my @result;

  if (ref $package eq 'ARRAY') {
    foreach my $pkg (@{$package}) {
      push @result, pkginfo ($pkg, \%version, \%providers);
    }
  } else {
    # there is at least one provider, as I assume builddeps are satisfied
    foreach my $provider (@{$providers{$package}}) {
      my $ver = $version{$provider};
      if (defined $ver) {
	if ($package eq $provider) {
	  push (@result, [ $provider, $ver ]);
	} else {
	  # pseudo package
	  push (@result, [ $provider, $ver, $package ]);
	}
      }
    }
  }

  return @result;
}

sub parse_control {
	my $control=shift || "debian/control";
	my %fields = ();

	open (CONTROL, $control) || die "$control: $!\n";
	local $/='';
	my $cdata=<CONTROL>;
	close CONTROL;

	my $dep_regex=qr/\s*((.|\n\s+)*)\s/; # allow multi-line
	if ($cdata =~ /^Build-Depends:$dep_regex/mi) {
		$fields{'Build-Depends'} = $1;
	}
	if ($cdata =~ /^Build-Conflicts:$dep_regex/mi) {
		$fields{'Build-Conflicts'} = $1;
	}
	if (! $binary_only && $cdata =~ /^Build-Depends-Indep:$dep_regex/mi) {
		$fields{'Build-Depends-Indep'} = $1;
	}
	if (! $binary_only && $cdata =~ /^Build-Conflicts-Indep:$dep_regex/mi) {
		$fields{'Build-Conflicts-Indep'} = $1;
	}

	return %fields;
}

1;
