# == Classification: Unclassified (provisional)
#
import "/etc/puppet/manifests/init.pp"
include stages
class {'dns':                stage => pre4 }
class {'nsswitch':           stage => pre4, type => 'ldap' }
class {'pkg_management':     stage => pre4 }
class {'pam':                stage => pre5, authentication => 'ldap'}
class {'ldap':           stage => pre5 }
