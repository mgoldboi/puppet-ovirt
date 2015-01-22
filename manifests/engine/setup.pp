# == Class: ovirt::engine
#
# The ovirt::engine class installs oVirt Engine.
#
# === Parameters
#
# [*application_mode*]
#   This setting can be used to override the default ovirt application mode of
#   both.  Valid options are both, virt, gluster.
#
# [*storage_type*]
#   This setting can be used to override the default ovirt storage type of nfs.
#   Valid options are nfs, fc, iscsi, and posixfs.
#
# [*organization*]
#   This setting can be used to override the default ovirt PKI organization of
#   localdomain.
#
# [*nfs_config_enabled*]
#   This setting can be used to override the default ovirt nfs configuration of
#   true.  Valid options are true and false.
#
# [*iso_domain_name*]
#   This setting can be used to override the default ISO Domain Name of
#   ISO_DOMAIN.
#
# [*iso_domain_mount_point*]
#   This setting can be used to override the default ISO Domain Mount Point
#   of /var/lib/exports/iso.
#
# [*admin_password*]
#   This setting can be used to override the default ovirt admin password of
#   admin.
#
# [*db_user*]
#   This setting can be used to override the default database user of engine.
#
# [*db_password*]
#   This setting can be used to override the default database password of
#   dbpassword.
#
# [*db_host*]
#   This setting can be used to override the default database host of localhost.
#
# [*db_port*]
#   This setting can be used to override the default database port of 5432.
#
# [*firewall_manager*]
#   This setting can be used to override the default firewall manager.  The
#   module uses iptables for RHEL and CentOS and firewalld for Fedora by
#   default.  Valid options are iptables and firewalld.
#
# === Examples
#
#  class { ovirt::engine:
#    application_mode => 'ovirt',
#    storage_type    => 'fc',
#    organization    => 'example.com',
#  }
class ovirt::engine::setup(
	$application_mode         = 'both', # both, virt, gluster
	$storage_type             = 'nfs', # nfs, fc, iscsi, posixfs
	$organization             = 'localdomain',
	$nfs_config_enabled       = true, # true, false
	$iso_domain_name          = 'ISO_DOMAIN',
	$iso_domain_mount_point   = '/var/lib/exports/iso',
	$admin_password           = 'admin',
	$db_user                  = 'engine',
	$db_password              = 'dbpassword',
	$db_host                  = 'localhost',
	$db_port                  = '5432',
	$storage_domain_dir       = '/var/lib/images',
	$firewall_manager = $::operatingsystem ? {
	  /(?i-mx:centos|redhat)/ => 'iptables',
	  /(?i-mx:fedora)/        => 'firewalld',},
	###############################################
	$url =           'https://localhost:443',
	$username =      'admin@internal',
	$password =      'admin',
	
){
	include ovirt::engine::packages
#	include ovirt::engine::config

	$answers_file='/var/lib/ovirt-engine/setup/answers/answers-from-puppet'

	file { $answers_file:
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		require => Package[ovirt-engine],
		content => template('ovirt/answers.erb'),
		}

	exec { 'engine-setup':
		require     => [
		  Package[ovirt-engine],
		  File[$answers_file],
		],
		#refreshonly => true,
		path        => '/usr/bin/:/bin/:/sbin:/usr/sbin',
		command     => "engine-setup --offline --config-append=${answers_file}",
		creates 	=> "/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf", 
		notify      => Service['ovirt-engine'],
		timeout     => 1800,
	  }

	service { 'ovirt-engine':
		ensure  => 'running',
		enable  => true,
		require => Exec['engine-setup'],
		}

	exec {'healthpage_check':
                require => Service['ovirt-engine'],
                command => "/usr/bin/curl --silent http://localhost/OvirtEngineWeb/HealthStatus > /tmp/rhev_health_output.txt && grep -q \"Welcome to Health Status\" /tmp/rhev_health_output.txt",
                creates => "/tmp/rhev_health_output.txt",
                refreshonly => true,
                tries => 10,
                timeout => 100,
                try_sleep => 10,
                notify => Class['ovirt::engine::config'],
                }

	file {'/root/.ovirtmshellrc':
		ensure => file,
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		content => template('ovirt/.ovirtshellrc.erb'),
		require => Service['ovirt-engine']
		}

}

