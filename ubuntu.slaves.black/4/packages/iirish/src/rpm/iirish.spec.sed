%define version @VERSION@

Name: iirish
Summary: Irish dictionary for Ispell
Version: %{version}
Release: 1
Group: Utilities/Text
Source: iirish_%{version}.orig.tar.gz
Copyright:  GPL
BuildRoot: /tmp/ispell-ga
Requires: ispell >= 3.1.20-5
BuildArchitectures: noarch
Prefix: /usr
Requires: ispell
Packager: Alastair McKinstry <mckinstry@computer.org>

%changelog
	* Fri Aug 16 2002 <mckinstry@computer.org>
		Now use scannell's word lists;
	
	* Thu Oct 30 1997 <mckinstry@computer.org>
		Fixed irish-prefixes.pl; more words.
	
	* Wed Oct 29 1997 <mckinstry@computer.org>
		Added gaeilge.4 man page;
		more corrections. 
	
	* Thu Oct 8 1997 <mckinstry@computer.org>
		Changed to BuildArchitectures: noarch

	* Sep 30 1997 <mckinstry@computer.org>
		Initial Release.

%description

This is an Irish  dictionary for ispell.

%prep
%setup 


%build
make irish.hash
mkdir -p $RPM_BUILD_ROOT/usr/lib/ispell
mkdir -p $RPM_BUILD_ROOT/usr/man/man4
cp irish.hash irish.aff  $RPM_BUILD_ROOT/usr/lib/ispell
#cp irish.4   $RPM_BUILD_ROOT/usr/man/man4/irish.4


%install

%post

EOF
fi


%files
%attr(644,root,root) /usr/lib/ispell/irish.hash
%attr(644,root,root) /usr/lib/ispell/irish.aff
#/usr/man/man4/irish.4
%doc COPYING
%doc ChangeLog
%doc README
