Name:       ovirt-puppet
Epoch:      1
Version:    0.0.1
Release:    1%{?dotalphatag}%{?dist}
Summary:    Collection of Puppet modules for oVirt deployment
Group:      Applications/System
License:    GPLv3+ and ASL 2.0
URL:        https://github.com/fusor
Source0:    %{name}-%{version}%{?dashalphatag}.tar.gz

BuildArch:  noarch

Requires:   puppet >= 2.7.0
BuildRequires: puppet >= 2.7.0
BuildRequires: hostname

%description
A collection of Puppet modules which are required to install and configure
oVirt via installers using Puppet configuration tool.

%prep
%setup -q -n %{name}-%{version}%{?dashalphatag}

%build
puppet module build .

%install
rm -rf %{buildroot}
install -d -m 0755 %{buildroot}/%{_datadir}/ovirt-puppet
cp -r * %{buildroot}/%{_datadir}/ovirt-puppet

%files
%{_datadir}/ovirt-puppet/*

%changelog

