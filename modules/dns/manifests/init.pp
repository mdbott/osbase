# == Classification: Unclassified (provisional)
#
# == Class: dns
#
# Sets up DNS servers in /etc/resolv.conf depending on environment
#
# == Future Directions
#
#
# == Parameters
#
#
# == Variables
#
#
# == Extlookup
#
# [*nameservers*]
#   Comma separated list of DNS servers to use
# [*dnssearchpath*]
#   Default DNS search path to set
#
# == Examples
#
#   include dns
#
# == Maintainers
#
# SSU
#
class dns {

  $nameservers   = extlookup("nameservers")
  $dnssearchpath = extlookup("dnssearchpath")


  # Add extra configuration import step for Solaris 11
  if "${::operatingsystem}${::operatingsystemrelease}" == 'Solaris5.11' {
    file { '/etc/resolv.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('dns/resolv.conf.Solaris5.11.erb'),
    }
    exec { 'import dns':
      command     => "/usr/sbin/nscfg import -f svc:/network/dns/client:default",
      refreshonly => true,
      subscribe   => File["/etc/resolv.conf"],
    }
    service {'dns/client':
      ensure     => running,
      enable     => true,
      require => Exec['import dns'],
    }
  } else {
    file { '/etc/resolv.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('dns/resolv.conf.erb'),
    }
  }
  
}
