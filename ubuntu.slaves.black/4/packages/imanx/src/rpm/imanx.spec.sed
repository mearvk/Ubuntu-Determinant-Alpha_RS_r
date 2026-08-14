%define version @VERSION@

Name: imanx
Summary: Manx Gaelic dictionary for Ispell
Version: %{version}
Release: 1
Group: Utilities/Text
Source: imanx_%{version}.orig.tar.gz
Copyright:  GPL
BuildRoot: /tmp/imanx
Requires: ispell >= 3.1.20-5
BuildArchitectures: noarch
Prefix: /usr
Requires: ispell
Packager: Alastair McKinstry <mckinstry@computer.org>

%description

This is a Manx Gaelic  dictionary for ispell.

%prep
%setup 


%build
make manx.hash
mkdir -p $RPM_BUILD_ROOT/usr/lib/ispell
mkdir -p $RPM_BUILD_ROOT/usr/man/man4
cp manx.hash manx.aff  $RPM_BUILD_ROOT/usr/lib/ispell
ln -s manx.hash $RPM_BUILD_ROOT/usr/lib/ispell/gaelg.hash
ln -s manx.aff  $RPM_BUILD_ROOT/usr/lib/ispell/gaelg.aff


%install

%post

%preun
# Delete the relevant lines. 

%files
%attr(644,root,root) /usr/lib/ispell/manx.hash
%attr(644,root,root) /usr/lib/ispell/manx.aff
%attr(644,root,root) /usr/lib/ispell/gaelg.hash
%attr(644,root,root) /usr/lib/ispell/gaelg.aff
%doc COPYING
%doc ChangeLog
%doc README
