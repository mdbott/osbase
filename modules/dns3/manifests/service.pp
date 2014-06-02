# == Classification: Unclassified (provisional)
#
class dns3::service{

  # Add extra configuration import step for Solaris 11
  if $dns3::params::dns3_conf_ver == 'Solaris11' {
    exec { 'import dns':
      command     => '/usr/sbin/nscfg import -f svc:/network/dns/client:default',
      refreshonly => true,
    }
    service {'dns/client':
      ensure  => running,
      enable  => true,
      require => Exec['import dns'],
    }
  }

}
