class ovirt::engine::run_vm(

        $url =           'https://localhost:443',
        $username =      'admin@internal',
        $password =      'admin',
        $dc_name =       'Default',
        $cluster_name =  'Default',
        $cpu_type =      'Intel Nehalem Family',
        $host_name =     'my_host',
        $host_address =  'host.fqdn',
        $root_password = 'redhat!!',
        $storage_name =  'my_storage',
        $storage_address = '192.168.112.1',
        $storage_path = '/usr/share/nfs/data2',
        $export_address = '192.168.112.1',
        $export_name =   'my_export',
        $export_path = '/usr/share/nfs/export',
        $storage_type =  'nfs',
	$template_name = '5c172af6-e0df-4542-9e92-c38680e54ce4',
) {
        require ovirt::engine::import_template
        $run_file='/var/lib/ovirt-engine/setup/engine-run-vm.py'

        file { $run_file:
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
#                require => Service['ovirt-engine'],
                content => template('ovirt/run_cfme.erb'),
                }
        notice ("configuration script added on \$config_file")

#        $healthy = $::ovirt_healthy
        #if fact not including dc notify exec
#        notify {"ovirt service is healthy? - ${healthy}":}
        exec { 'run_cfme':
                require     => [
                  Service['ovirt-engine'],
                  File[$run_file],
                ],
#               onlyif => "test ${healthy} = true",
#               refreshonly => true,
                path        => '/usr/bin/:/bin/:/sbin:/usr/sbin',
                command     => "python ${run_file}",
                logoutput => true,#"on_failure",
                timeout     => 3600,
#                tries => 1,
#                try_sleep => 10,
                }
}

