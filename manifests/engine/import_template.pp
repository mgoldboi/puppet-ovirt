class ovirt::engine::import_template(
	$url =           'https://localhost:443',
        $username =      'admin@internal',
        $password =      'changeme',
        $dc_name =       'Default',
        $cluster_name =  'Default',
        $cpu_type =      'Intel Nehalem Family',
        $host_name =     'my_host',
        $host_address =  'host.fqdn',
        $root_password = 'changeme',
        $storage_name =  'my_storage',
        $storage_address = 'ip.address',
        $storage_path = '/path/to/share',
        $export_address = 'ip.address',
        $export_name =   'my_export',
        $export_path = '/pass/to/share',
        $storage_type =  'nfs',
	$template_name = '5c172af6-e0df-4542-9e92-c38680e54ce4',
	$cfme_hostname = 'cfme.fqdn',
	
) {
        require ovirt::engine::config

        $import_file='/var/lib/ovirt-engine/setup/engine-template-import.py'

        file { $import_file:
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                require => Service['ovirt-engine'],
                content => template('ovirt/template_import.erb'),
                }
        notice ("configuration script added on \$config_file")

        exec { 'engine_template_import':
                require     => [
                  Service['ovirt-engine'],
                  File[$import_file],
                ],
#               onlyif => "test ${healthy} = true",
#               refreshonly => true,
                path        => '/usr/bin/:/bin/:/sbin:/usr/sbin',
                command     => "python ${import_file}",
                logoutput => true,#"on_failure",
                timeout     => 3600,
#                tries => 1,
#                try_sleep => 10,
                }
}

