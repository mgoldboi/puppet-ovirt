class ovirt::engine::packages {
	require ovirt::repo
	notify {"oVirt Package installation stage- Done":}
	if $ovirt::product == 'oVirt'{
		package { 'ovirt-engine':
			ensure  => installed,
	#		require => Yumrepo['ovirt'],
			require => Package[$ovirt::repo::ovirt_release],
	#    notify  => Exec[$ovirtm::engine::setup::engine-setup],
		}
	}
	elif $ovirt::product == 'RHEV'{
		package { 'rhevm':
	                ensure  => installed,
        	        require => Yumrepo['rhevm'],
		}
	}

}
