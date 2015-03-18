# == Class: ovirt
#
# This class contains the common requirements of ovirt::engine and ovirt::node.
#
# === Parameters
#
# [*ovirt_release_base_url*]
#   This setting can be used to override the default url of http://ovirt.org/releases.
#
# === Authors
#
# Jason Cannon <jason@thisidig.com>
#
class ovirt(
	 $product =           'ovirt', 
){}
