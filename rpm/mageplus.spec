%define applicationdir /usr/local/%{opt_project}/app/magento


%if "%{opt_suffix}" == ""
Name: mageplus-app-%{opt_project}
%else
Name: mageplus-app-%{opt_project}-%{opt_suffix}
%endif
Version: %{opt_version}
Release: %{opt_release}
Group: Mage+
URL: http://mageplus.org
Summary: Mage+ package.
Vendor: Mage+
License: OSL v3.0


BuildRoot: /var/tmp/%{name}-buildroot

Requires: httpd >= 2.2
BuildArch: x86_64


AutoReqProv: no
%define __jar_repack %{nil}
%define __os_install_post \
    /usr/lib/rpm/redhat/brp-compress \
    %{!?__debug_package:/usr/lib/rpm/redhat/brp-strip %{__strip}} \
    /usr/lib/rpm/redhat/brp-strip-static-archive %{__strip} \
    /usr/lib/rpm/redhat/brp-strip-comment-note %{__strip} %{__objdump} \
    /usr/lib/rpm/brp-python-bytecompile %{nil}


%description
Mage+ package.


%prep
:


%build
:


%install
mkdir -p $RPM_BUILD_ROOT/%{applicationdir}
cd %{opt_sourcedir}
cp -a . $RPM_BUILD_ROOT/%{applicationdir}


%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-, magento, magento)
%{applicationdir}


%pre
/usr/sbin/groupadd -g 20006 magento > /dev/null 2>&1
/usr/sbin/useradd -u 20006 -g 20006 -c "Magento user" -d %{applicationdir} \
        -s /bin/false magento > /dev/null 2>&1
exit 0


%changelog
* Mon Jul 22 2013 Lee Bolding lee@mageplus.org
- Initial version of .spec file.
