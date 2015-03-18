# == Class: ovirt
#
# This class contains the common requirements of ovirt::engine and ovirt::node.
#
# === Parameters
#
# [*ovirt_release_base_url*]
#   This setting can be used to override the default url of http://ovirt.org/releases.
#
class ovirt::repo(
$ovirt_release_base_url = 'http://resources.ovirt.org/pub/yum-repo/')
{
	if $product == 'oVirt'{

		case $::operatingsystem {
			centos, redhat: {
				$ovirt_release     = 'ovirt-release35'
				$ovirt_release_url = "${ovirt_release_base_url}/ovirt-release35.rpm"
			}
			fedora: {
				$ovirt_release     = 'ovirt-release-fedora'
				$ovirt_release_url = "${ovirt_release_base_url}/${ovirt_release}.noarch.rpm"
			}
			default: {
				fail("The ${::operatingsystem} operating system is not supported.")
				}
			}	

			package { $ovirt_release:
				  ensure   => installed,
				  provider => 'rpm',
				  source   => $ovirt_release_url,
			}
			notify {"deploying needed repositories":}

	elif $product == 'RHEV'{
		yumrepo { 'rhevm':
	                baseurl  => 'http://bob.eng.lab.tlv.redhat.com/builds/latest_vt/',
	                descr    => 'Red Hat Enterprise Virtualization Manager',
	                enabled  => '1',
	                gpgcheck => '0',
	                }
		yumrepo { 'jboss':
	                baseurl  => 'http://download.eng.rdu2.redhat.com/devel/candidates/JBEAP/composing/latest-JBEAP-6.3-RHEL-6/compose/Server/x86_64/os/',
	                descr    => 'Jboss',
        	        enabled  => '1',
                	gpgcheck => '0',
	                }
		yumrepo { 'RHEL6.6base':
			baseurl  => 'http://download.eng.bos.redhat.com/released/RHEL-6/6.6/Server/x86_64/os/',
	                descr    => 'RHEL_66',
        	        enabled  => '1',
                	gpgcheck => '0',
	                }
		yumrepo { 'RHEL6.6optional':
			 baseurl  => 'http://download.eng.bos.redhat.com/released/RHEL-6/6.6/Server/optional/x86_64/os/',
	                descr    => 'RHEL_66_optional',
        	        enabled  => '1',
	                gpgcheck => '0',
	                }
	}
}
