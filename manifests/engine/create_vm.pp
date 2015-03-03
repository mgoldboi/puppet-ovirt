class ovirt::engine::create_vm(

        $url =           'https://localhost:443',
        $username =      'admin@internal',
        $password =      'admin',
        $dc_name =       'Default',
        $cluster_name =  'Default',
        $cpu_type =      'Intel Nehalem Family',
        $host_name =     'my_host',
        $host_address =  'hypervisor.fqdn',
        $root_password = 'changeme',
        $storage_name =  'my_storage',
        $storage_address = '192.168.112.1',
        $storage_path = '/path/to/share',
        $export_address = '192.168.112.1',
        $export_name =   'my_export',
        $export_path = '/path/to/share',
        $storage_type =  'nfs',
	$template_name = 'template_name',
) {
#       include ovirt::engine::packages
#       include ovirt::engine::setup
	include ovirt::engine::config

        $import_file='/var/lib/ovirt-engine/setup/import_template_to_vm.py'

        file { $import_file:
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                require => Service['ovirt-engine'],
                content => template('ovirt/import_template_to_vm.erb'),
                }
        notice ("configuration script added on \$config_file")

#        $healthy = $::ovirt_healthy
        #if fact not including dc notify exec
#        notify {"ovirt service is healthy? - ${healthy}":}
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
