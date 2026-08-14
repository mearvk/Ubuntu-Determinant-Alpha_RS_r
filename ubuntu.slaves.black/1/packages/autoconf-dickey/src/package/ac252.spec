Summary: autoconf-252 - Generate configuration scripts
%define AppProgram autoconf
%define AppVersion 2.52
%define AppRelease 20210509
%define AppSuffix  -252
# $Id: ac252.spec,v 1.35 2021/05/09 17:53:30 tom Exp $
Name: ac252
Version: %{AppVersion}
Release: %{AppRelease}
License: GPLv2
Group: Applications/Development
URL: ftp://ftp.invisible-island.net/%{AppProgram}
Source0: %{AppProgram}-%{AppVersion}-%{AppRelease}.tgz
Packager: Thomas E. Dickey <dickey@invisible-island.net>

BuildArch:	noarch
#BuildRequires:	m4
Requires:	m4

%description
This is a stable version of autoconf, used by all of my applications.
See http://invisible-island.net/autoconf/

%define MyName %{AppProgram}%{AppSuffix}

%define find_tool tool=install-info; for dir in /sbin /usr/sbin; do if test -f $dir/$tool; then tool=$dir/$tool;break;fi;done

%prep

%setup -q -n %{AppProgram}-%{AppVersion}-%{AppRelease}

%build

INSTALL_PROGRAM='${INSTALL}' \
	./configure \
		--program-suffix=%{AppSuffix} \
		--target %{_target_platform} \
		--prefix=%{_prefix} \
		--bindir=%{_bindir} \
		--mandir=%{_mandir} \
		--datadir=%{_datadir}/%{MyName} \
		--infodir=%{_infodir}

make

%install
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT

make install                    DESTDIR=$RPM_BUILD_ROOT
rm -f $RPM_BUILD_ROOT%{_infodir}/dir
rm -f $RPM_BUILD_ROOT%{_infodir}/standards*

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT

%post
%{find_tool}
$tool \
	%{_infodir}/%{MyName}.info \
	%{_infodir}/dir || :

%preun
if [ $1 = 0 ] ; then
  %{find_tool}
  $tool \
	--delete \
	%{_infodir}/%{MyName}.info \
	%{_infodir}/dir || :
fi

%files
%defattr(-,root,root)
%{_bindir}/*%{AppSuffix}
%{_mandir}/man1/*%{AppSuffix}*
%{_datadir}/%{MyName}*
%{_infodir}/*%{AppSuffix}*

%changelog
# each patch should add its ChangeLog entries here

* Sun Aug 19 2018 Thomas E. Dickey
- update ftp-url

* Fri Oct 01 2010 Thomas E. Dickey
- adapt rules for installing info file from
  http://fedoraproject.org/wiki/Packaging/ScriptletSnippets

* Tue Sep 28 2010 Thomas E. Dickey
- initial version
