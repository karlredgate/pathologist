%define revcount %(git rev-list HEAD | wc -l)
%define treeish %(git rev-parse --short HEAD)
%define localmods %(git diff-files --exit-code --quiet  || date +.m%%j%%H%%M%%S)

%define srcdir   %{getenv:PWD}

Summary: Pathologist Diagnostics Tools
Name: pathologist
Version: 1.0
Release: %{revcount}.%{treeish}%{localmods}
Distribution: Redgate
Group: System Environment/Tools
License: Proprietary
Vendor: Karl Redgate
Packager: Karl Redgate <Karl.Redgate@gmail.com>
%define _topdir %(echo $PWD)/rpm
BuildRoot: %{_topdir}/BUILDROOT

Requires(pre): coreutils

# The following for script tools/libvirt-log-level
Requires(post): sed

%description
Tools for diagnosing Redgate managed systems.

%prep
%build

: %install
: __PKG_SRCDIR=%{srcdir}
: __PKG_BUILD_ROOT=$RPM_BUILD_ROOT
: %include install.bash

install --directory --mode=755 $RPM_BUILD_ROOT/etc/sysconfig/
install --mode=644 %{srcdir}/sysconfig/* $RPM_BUILD_ROOT/etc/sysconfig/

install --directory --mode=755 $RPM_BUILD_ROOT/etc/init
install --mode=644 %{srcdir}/etc/init/*.conf $RPM_BUILD_ROOT/etc/init/

: install --directory --mode=755 $RPM_BUILD_ROOT/etc/pki/dialout
: install --mode=644 %{srcdir}/pki/dialout/* $RPM_BUILD_ROOT/etc/pki/dialout/

install --directory --mode=755 $RPM_BUILD_ROOT/usr/bin
install --mode=755 %{srcdir}/bin/* $RPM_BUILD_ROOT/usr/bin/

install --directory --mode=755 $RPM_BUILD_ROOT/usr/share/pathologist/diagnostics/xslt
install --mode=644 %{srcdir}/xslt/*.xslt $RPM_BUILD_ROOT/usr/share/pathologist/diagnostics/xslt

: libexec=libexec/pathologist/diagnostics
: install --directory --mode=755 $RPM_BUILD_ROOT/usr/$libexec/dialin-hooks
: install --mode=755 %{srcdir}/$libexec/* $RPM_BUILD_ROOT/usr/$libexec/
: install --mode=755 %{srcdir}/dialin-hooks/* $RPM_BUILD_ROOT/usr/$libexec/dialin-hooks/
tar -cf - -C %{srcdir} libexec | tar -xf - -C $RPM_BUILD_ROOT/usr

install --directory --mode=755 $RPM_BUILD_ROOT/etc/cron.d
install --mode=644 %{srcdir}/cron.d/* $RPM_BUILD_ROOT/etc/cron.d/

install --directory --mode=755 $RPM_BUILD_ROOT/etc/cron.daily
install --mode=755 %{srcdir}/cron.daily/* $RPM_BUILD_ROOT/etc/cron.daily/

install --directory --mode=755 $RPM_BUILD_ROOT/etc/cron.reboot
install --mode=755 %{srcdir}/cron.reboot/* $RPM_BUILD_ROOT/etc/cron.reboot/

install --directory --mode=755 $RPM_BUILD_ROOT/etc/rsyslog.d
install --mode=644 %{srcdir}/rsyslog.d/* $RPM_BUILD_ROOT/etc/rsyslog.d/

install --directory --mode=755 $RPM_BUILD_ROOT/etc/sudoers.d
install --mode=644 %{srcdir}/sudoers.d/* $RPM_BUILD_ROOT/etc/sudoers.d/

install --directory --mode=755 $RPM_BUILD_ROOT/var/log/pathologist/diagnostics
install --directory --mode=755 $RPM_BUILD_ROOT/var/spool/pathologist/diagnostics

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,0755)
%config /etc/sysconfig/pathologist
/etc/init/inventory.conf
# /etc/pki/dialout/
/etc/sudoers.d/diagnostics
/etc/cron.d/
/etc/cron.reboot/
/etc/cron.daily/
/etc/rsyslog.d/
/usr/bin/*
/usr/share/pathologist/diagnostics/
/usr/libexec/pathologist/diagnostics/
/var/log/pathologist/diagnostics/
/var/spool/pathologist/diagnostics/

%pre
# rm -f /etc/yum.repos.d/*

%post

: change exit status so upgrade doesnt fail

%changelog
* Mon Nov 11 2013 Karl Redgate <www.redgates.com>
- First package

