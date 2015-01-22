class ovirt::engine::packages {
	include ovirt::repo
	package { 'ovirt-engine':
		ensure  => installed,
#		require => Yumrepo['ovirt'],
		require => Package[$ovirt::repo::ovirt_release],
#    notify  => Exec[$ovirtm::engine::setup::engine-setup],
	}
}
