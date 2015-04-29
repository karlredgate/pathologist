%define revcount %(git rev-list HEAD | wc -l)
%define treeish %(git rev-parse --short HEAD)
%define localmods %(git diff-files --exit-code --quiet  || date +.m%%j%%H%%M%%S)

%define srcdir   %{getenv:PWD}

Summary: Redgate Diagnostics Tools
Name: redgate-diagnostics
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
Tools for diagnosing RedX managed systems.

%prep
%build

%install
install --directory --mode=755 $RPM_BUILD_ROOT/etc/sysconfig/redgate
install --mode=644 %{srcdir}/sysconfig/redgate/* $RPM_BUILD_ROOT/etc/sysconfig/redgate/

install --directory --mode=755 $RPM_BUILD_ROOT/etc/init
install --mode=644 %{srcdir}/etc/init/*.conf $RPM_BUILD_ROOT/etc/init/

install --directory --mode=755 $RPM_BUILD_ROOT/etc/pki/dialout
install --mode=644 %{srcdir}/pki/dialout/* $RPM_BUILD_ROOT/etc/pki/dialout/

install --directory --mode=755 $RPM_BUILD_ROOT/usr/bin
install --mode=755 %{srcdir}/bin/* $RPM_BUILD_ROOT/usr/bin/

install --directory --mode=755 $RPM_BUILD_ROOT/usr/share/redgate/diagnostics/xslt
install --mode=644 %{srcdir}/xslt/*.xslt $RPM_BUILD_ROOT/usr/share/redgate/diagnostics/xslt

libexec=libexec/redgate/diagnostics
install --directory --mode=755 $RPM_BUILD_ROOT/usr/$libexec/dialin-hooks
install --mode=755 %{srcdir}/$libexec/* $RPM_BUILD_ROOT/usr/$libexec/
install --mode=755 %{srcdir}/dialin-hooks/* $RPM_BUILD_ROOT/usr/$libexec/dialin-hooks/

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

install --directory --mode=755 $RPM_BUILD_ROOT/var/log/redgate/diagnostics
install --directory --mode=755 $RPM_BUILD_ROOT/var/spool/redgate/diagnostics

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,0755)
%config /etc/sysconfig/redgate/diagnostics
/etc/init/inventory.conf
/etc/pki/dialout/
/etc/sudoers.d/diagnostics
/etc/cron.d/
/etc/cron.reboot/
/etc/cron.daily/
/etc/rsyslog.d/
/usr/bin
/usr/share/redgate/diagnostics/
/usr/libexec/redgate/diagnostics/
/var/log/redgate/diagnostics/
/var/spool/redgate/diagnostics/

%pre
# rm -f /etc/yum.repos.d/*

%post

: change exit status so upgrade doesnt fail

%changelog
* Mon Nov 11 2013 Karl Redgate <www.redgates.com>
- First package

