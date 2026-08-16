#
# Copyright (C)  Heinz Mauelshagen, 2004-2009 Red Hat GmbH. All rights reserved.
#
# See file LICENSE at the top of this source tree for license information.
#

Summary: dmraid (Device-mapper RAID tool and library)
Name: dmraid
Version: 1.0.0.rc16
Release: 1%{?dist}
License: GPLv2+
Group: System Environment/Base
URL: http://people.redhat.com/heinzm/sw/dmraid
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
BuildRequires: device-mapper >= 1.02.02-2, libselinux-devel, libsepol-devel
Requires: dmraid-events kpartx
Requires(postun): ldconfig
Requires(post): ldconfig
Source: ftp://people.redhat.com/heinzm/sw/dmraid/src/%{name}-%{version}.tar.bz2

%description
DMRAID supports RAID device discovery, RAID set activation, creation,
removal, rebuild and display of properties for ATARAID/DDF1 metadata on
Linux >= 2.4 using device-mapper.

%package -n dmraid-devel
Summary: Development libraries and headers for dmraid.
Group: Development/Libraries
License: GPLv2+
Requires: %{name} = %{version}-%{release}
Requires: %{name}-libs = %{version}-%{release}

%description -n dmraid-devel
dmraid-devel provides a library interface for RAID device discovery,
RAID set activation and display of properties for ATARAID volumes.

%package -n dmraid-events
Summary: dmevent_tool (Device-mapper event tool) and DSO
Group: System Environment/Base
Requires: dmraid = %{version}-%{release}, sgpio

%description -n dmraid-events
Provides a dmeventd DSO and the dmevent_tool to register devices with it
for device monitoring.  All active RAID sets should be manually registered
with dmevent_tool.

%package -n dmraid-events-logwatch
Summary: dmraid logwatch-based email reporting
Group: System Environment/Base
Requires: dmraid-events = %{version}-%{release}, logwatch, /etc/cron.d

%description -n dmraid-events-logwatch
Provides device failure reporting via logwatch-based email reporting.
Device failure reporting has to be activated manually by activating the 
/etc/cron.d/dmeventd-logwatch entry and by calling the dmevent_tool
(see manual page for examples) for any active RAID sets.

%prep
%setup -q -n dmraid/%{version}

%build
%configure --prefix=${RPM_BUILD_ROOT}/usr --sbindir=${RPM_BUILD_ROOT}/sbin --libdir=${RPM_BUILD_ROOT}/%{_libdir} --mandir=${RPM_BUILD_ROOT}/%{_mandir} --includedir=${RPM_BUILD_ROOT}/%{_includedir} --enable-debug --enable-libselinux --enable-libsepol --enable-static_link --enable-led --enable-intel_led
make DESTDIR=$RPM_BUILD_ROOT
mv tools/dmraid tools/dmraid.static
make clean
%configure --prefix=${RPM_BUILD_ROOT}/usr --sbindir=${RPM_BUILD_ROOT}/sbin --libdir=${RPM_BUILD_ROOT}/%{_libdir} --mandir=${RPM_BUILD_ROOT}/%{_mandir} --includedir=${RPM_BUILD_ROOT}/%{_includedir} --enable-debug --enable-libselinux --enable-libsepol --disable-static_linko --enable-led --enable-intel_led
make DESTDIR=$RPM_BUILD_ROOT

%install
rm -rf $RPM_BUILD_ROOT
install -m 755 -d $RPM_BUILD_ROOT{%{_libdir},/sbin,%{_sbindir},%{_bindir},%{_libdir},%{_includedir}/dmraid/,/var/lock/dmraid,/etc/cron.d/,/etc/logwatch/conf/services/,/etc/logwatch/scripts/services/}
make DESTDIR=$RPM_BUILD_ROOT install

# Install static dmraid binary
install -m 755 tools/dmraid.static $RPM_BUILD_ROOT/sbin/dmraid.static

# Provide convenience link from dmevent_tool
(cd $RPM_BUILD_ROOT/sbin ; ln -f dmevent_tool dm_dso_reg_tool)
install -m 644 include/dmraid/*.h $RPM_BUILD_ROOT%{_includedir}/dmraid/

# If requested, install the libdmraid and libdmraid-events (for dmeventd) DSO
install -m 755 lib/libdmraid.so \
	$RPM_BUILD_ROOT%{_libdir}/libdmraid.so.%{version}
(cd $RPM_BUILD_ROOT/%{_libdir} ; ln -sf libdmraid.so.%{version} libdmraid.so)
install -m 755 lib/libdmraid-events-isw.so \
	$RPM_BUILD_ROOT%{_libdir}/libdmraid-events-isw.so.%{version}
(cd $RPM_BUILD_ROOT/%{_libdir} ; ln -sf libdmraid-events-isw.so.%{version} libdmraid-events-isw.so)

# Install logwatch config file and script for dmeventd
install -m 644 logwatch/dmeventd.conf $RPM_BUILD_ROOT/etc/logwatch/conf/services/dmeventd.conf
install -m 755 logwatch/dmeventd $RPM_BUILD_ROOT/etc/logwatch/scripts/services/dmeventd
install -m 644 logwatch/dmeventd_cronjob.txt $RPM_BUILD_ROOT/etc/cron.d/dmeventd-logwatch
install -m 0700 /dev/null $RPM_BUILD_ROOT/etc/logwatch/scripts/services/dmeventd_syslogpattern.txt

rm -f $RPM_BUILD_ROOT/%{_libdir}/libdmraid.a

%clean
rm -rf $RPM_BUILD_ROOT

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig

%files
%defattr(-,root,root)
%doc CHANGELOG CREDITS KNOWN_BUGS LICENSE LICENSE_GPL LICENSE_LGPL README TODO doc/dmraid_design.txt
/%{_mandir}/man8/dmraid*
/sbin/dmraid
/sbin/dmraid.static
%{_libdir}/libdmraid.so*
%{_libdir}/libdmraid-events-isw.so*
/var/lock/dmraid

%files -n dmraid-devel
%defattr(-,root,root)
%dir %{_includedir}/dmraid
%{_includedir}/dmraid/*

%files -n dmraid-events
%defattr(-,root,root)
/%{_mandir}/man8/dmevent_tool*
/sbin/dmevent_tool
/sbin/dm_dso_reg_tool

%files -n dmraid-events-logwatch
%defattr(-,root,root)
%config(noreplace) /etc/logwatch/*
%config(noreplace) /etc/cron.d/dmeventd-logwatch
%ghost /etc/logwatch/scripts/services/dmeventd_syslogpattern.txt

%changelog
* Thu Sep 16 2009 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16
- Update to version 1.0.0.rc16

* Fri Apr 17 2009 Hans de Goede <hdegoede@redhat.com> - 1.0.0.rc15-7
- Fix activation of isw raid sets when the disks have serialnumber longer
  then 16 characters (#490121)

* Tue Feb 24 2009 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.0.0.rc15-6
- Rebuilt for https://fedoraproject.org/wiki/Fedora_11_Mass_Rebuild

* Fri Feb 13 2009 Hans de Goede <hdegoede@redhat.com> - 1.0.0.rc15-5
- Make --rm_partitions work with older kernels which return EINVAL when trying
  to remove a partition with a number > 16
- Document --rm_partitions in the man page

* Thu Feb 12 2009 Hans de Goede <hdegoede@redhat.com> - 1.0.0.rc15-4
- Add patch adding --rm_partitions cmdline option and functionality (#484845)

* Thu Feb  5 2009 Hans de Goede <hdegoede@redhat.com> - 1.0.0.rc15-3
- Fix mismatch between BIOS and dmraid's view of ISW raid 10 sets

* Tue Nov 18 2008 Bill Nottingham <notting@redhat.com> - 1.0.0.rc15-2
- Re-add upstream whitespace removal patch (#468649, #470634)

* Thu Sep 25 2008 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc15-1
- Update to version 1.0.0.rc15

* Thu Jul 03 2008 Alasdair Kergon <agk@redhat.com> - 1.0.0.rc14-8
- Move library into libs subpackage.
- Fix summary and licence tags.
- Replace static build with symlink.

* Tue Feb 19 2008 Fedora Release Engineering <rel-eng@fedoraproject.org> - 1.0.0.rc14-7
- Autorebuild for GCC 4.3

* Wed Nov 21 2007 Ian Kent <ikent@redhat.com> - 1.0.0.rc14-6
- Bug 379911: dmraid needs to generate UUIDs for lib device-mapper
  - add "DMRAID-" prefix to dmraid UUID string.

* Wed Nov 14 2007 Ian Kent <ikent@redhat.com> - 1.0.0.rc14-5
- Bug 379911: dmraid needs to generate UUIDs for lib device-mapper
- Bug 379951: dmraid needs to activate device-mapper mirror resynchronization error handling

* Mon Oct 22 2007 Ian Kent <ikent@redhat.com> - 1.0.0.rc14-4
- Fix SEGV on "dmraid -r -E" (bz 236891).

* Wed Apr 18 2007 Peter Jones <pjones@redhat.com> - 1.0.0.rc14-3
- Fix jmicron name parsing (#219058)

* Mon Feb 05 2007 Alasdair Kergon <agk@redhat.com> - 1.0.0.rc14-2
- Add build dependency on new device-mapper-devel package.
- Add dependency on device-mapper.
- Add post and postun ldconfig.
- Update BuildRoot and Summary.

* Wed Nov 08 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc14-1
- asr.c: fixed Adaptec HostRAID DDF1 metadata discovery (bz#211016)
- ddf1_crc.c: added crc() routine to avoid linking to zlib alltogether,
              because Ubuntu had problems with this
- dropped zlib build requirement

* Thu Oct 26 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc14-bz211016-1
- ddf1.c: get_size() fixed (bz#211016)
- ddf1_lib.c: ddf1_cr_off_maxpds_helper() fixed (bz#211016)

* Wed Oct 11 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc13-1
- metadata.c: fixed bug returning wrang unified RAID type (bz#210085)
- pdc.c: fixed magic number check

* Sun Oct 01 2006 Jesse Keating <jkeating@redhat.com> - 1.0.0.rc12-7
- rebuilt for unwind info generation, broken in gcc-4.1.1-21

* Fri Sep 22 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc12-1
- sil.c: quorate() OBO fix
- activate.c: handler() OBO fix
- added SNIA DDF1 support
- added reload functionality to devmapper.c
- added log_zero_sectors() to various metadata format handlers
- sil.[ch]: added JBOD support

* Fri Sep  1 2006 Peter Jones <pjones@redhat.com> - 1.0.0.rc11-4
- Require kpartx, so initscripts doesn't have to if you're not using dmraid

* Thu Aug 17 2006 Jesse Keating <jkeating@redhat.com> - 1.0.0.rc11-3
- Change Release to follow guidelines, and add dist tag.

* Thu Aug 17 2006 Peter Jones <pjones@redhat.com> - 1.0.0.rc11-FC6.3
- No more excludearch for s390/s390x

* Fri Jul 28 2006 Peter Jones <pjones@redhat.com> - 1.0.0.rc11-FC6.2
- Fix bounds checking on hpt37x error log
- Only build the .so, not the .a
- Fix asc.c duplication in makefile rule

* Wed Jul 12 2006 Jesse Keating <jkeating@redhat.com> - 1.0.0.rc11-FC6.1.1
- rebuild

* Fri Jul  7 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc11-FC6.1
- rebuilt for FC6 with dos partition discovery fix (#197573)

* Tue May 16 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc11-FC6
- rebuilt for FC6 with better tag

* Tue May 16 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc11-FC5_7.2
- rebuilt for FC5

* Tue May 16 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc11-FC5_7.1
- jm.c: checksum() calculation
- misc.c: support "%d" in p_fmt and fix segfault with wrong format identifier
- nv.c: size fix in setup_rd()
- activate.c:
        o striped devices could end on non-chunk boundaries
        o calc_region_size() calculated too small sizes causing large
          dirty logs in memory
- isw.c: set raid5 type to left asymmetric
- toollib.c: fixed 'No RAID...' message
- support selection of RAID5 allocation algorithm in metadata format handlers
- build

* Mon Mar 27 2006 Milan Broz <mbroz@redhat.com> - 1.0.0.rc10-FC5_6.2
- fixed /var/lock/dmraid in specfile (#168195)

* Fri Feb 17 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc10-FC5_6
- add doc/dmraid_design.txt to %doc (#181885)
- add --enable-libselinux --enable-libsepol to configure
- rebuilt

* Fri Feb 10 2006 Jesse Keating <jkeating@redhat.com> - 1.0.0.rc9-FC5_5.2
- bump again for double-long bug on ppc(64)

* Tue Feb 07 2006 Jesse Keating <jkeating@redhat.com> - 1.0.0.rc9-FC5_5.1
- rebuilt for new gcc4.1 snapshot and glibc changes

* Sun Jan 22 2006 Peter Jones <pjones@redhat.com> 1.0.0.rc9-FC5_5
- Add selinux build deps
- Don't set owner during make install

* Fri Dec  9 2005 Jesse Keating <jkeating@redhat.com> 1.0.0.rc9-FC5_4.1
- rebuilt

* Sun Dec  3 2005 Peter Jones <pjones@redhat.com> 1.0.0.rc9-FC5_4
- rebuild for device-mapper-1.02.02-2

* Fri Dec  2 2005 Peter Jones <pjones@redhat.com> 1.0.0.rc9-FC5_3
- rebuild for device-mapper-1.02.02-1

* Thu Nov 10 2005 Peter Jones <pjones@redhat.com> 1.0.0.rc9-FC5_2
- update to 1.0.0.rc9
- make "make install" do the right thing with the DSO
- eliminate duplicate definitions in the headers
- export more symbols in the DSO
- add api calls to retrieve dm tables
- fix DESTDIR for 'make install' 
- add api calls to identify degraded devices
- remove several arch excludes

* Sat Oct 15 2005 Florian La Roche <laroche@redhat.com>
- add -lselinux -lsepol for new device-mapper deps

* Fri May 20 2005 Heinz Mauelshagen <heinzm@redhat.com> 1.0.0.rc8-FC4_2
- specfile change to build static and dynamic binray into one package
- rebuilt

* Thu May 19 2005 Heinz Mauelshagen <heinzm@redhat.com> 1.0.0.rc8-FC4_1
- nv.c: fixed stripe size
- sil.c: avoid incarnation_no in name creation, because the Windows
         driver changes it every time
- added --ignorelocking option to avoid taking out locks in early boot
  where no read/write access to /var is given

* Wed Mar 16 2005 Elliot Lee <sopwith@redhat.com>
- rebuilt

* Tue Mar 15 2005 Heinz Mauelshagen <heinzm@redhat.com> 1.0.0.rc6.1-4_FC4
- VIA metadata format handler
- added RAID10 to lsi metadata format handler
- "dmraid -rD": file device size into {devicename}_{formatname}.size
- "dmraid -tay": pretty print multi-line tables ala "dmsetup table"
- "dmraid -l": display supported RAID levels + manual update
- _sil_read() used LOG_NOTICE rather than LOG_INFO in order to
  avoid messages about valid metadata areas being displayed
  during "dmraid -vay".
- isw, sil filed metadata offset on "-r -D" in sectors rather than in bytes.
- isw needed dev_sort() to sort RAID devices in sets correctly.
- pdc metadata format handler name creation. Lead to
  wrong RAID set grouping logic in some configurations.
- pdc RAID1 size calculation fixed (rc6.1)
- dos.c: partition table code fixes by Paul Moore
- _free_dev_pointers(): fixed potential OOB error
- hpt37x_check: deal with raid_disks = 1 in mirror sets
- pdc_check: status & 0x80 doesn't always show a failed device;
  removed that check for now. Status definitions needed.
- sil addition of RAID sets to global list of sets
- sil spare device memory leak
- group_set(): removal of RAID set in case of error
- hpt37x: handle total_secs > device size
- allow -p with -f
- enhanced error message by checking target type against list of
  registered target types

* Fri Jan 21 2005 Alasdair Kergon <agk@redhat.com> 1.0.0.rc5f-2
- Rebuild to pick up new libdevmapper.

* Fri Nov 26 2004 Heinz Mauelshagen <heinzm@redhat.com> 1.0.0.rc5f
- specfile cleanup

* Tue Aug 20 2004 Heinz Mauelshagen <heinzm@redhat.com> 1.0.0-rc4-pre1
- Removed make flag after fixing make.tmpl.in

* Tue Aug 18 2004 Heinz Mauelshagen <heinzm@redhat.com> 1.0.0-rc3
- Added make flag to prevent make 3.80 from looping infinitely

* Thu Jun 17 2004 Heinz Mauelshagen <heinzm@redhat.com> 1.0.0-pre1
- Created
