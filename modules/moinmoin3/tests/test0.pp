# == Classification: Unclassified (provisional)
#
import "/etc/puppet/manifests/init.pp"
include dns3
class {'nsswitch': type => 'local' }
