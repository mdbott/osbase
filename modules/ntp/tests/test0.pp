# Classification: Unclassified (provisional)
import "/etc/puppet/manifests/init.pp"
include stages
class {'dns':                stage => pre4 }
class {'nsswitch':           stage => pre4, type => 'local' }
class {'pkg_management': stage => pre4 }
include ntp
