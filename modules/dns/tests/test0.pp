# == Classification: Unclassified (provisional)

import "/etc/puppet/manifests/init.pp"
include dns
class {'nsswitch': type => 'local' }
