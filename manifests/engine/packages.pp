class ovirt::engine::packages {
	require ovirt::repo
	notify {"oVirt Package installation stage- Done":}
	package { 'ovirt-engine':
		ensure  => installed,
#		require => Yumrepo['ovirt'],
		require => Package[$ovirt::repo::ovirt_release],
#    notify  => Exec[$ovirtm::engine::setup::engine-setup],
	}
}
