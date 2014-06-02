# == Classification: Unclassified (provisional)
#
class glusterold::config {
  # Setup concat module
  include concat::setup

  # Setup node config file for concat module and include first fragment
  concat { "${glusterold::params::configdir}/glusterfsd.vol":
    owner   => 'root',
    group   => 'root',
    require => Class['glusterold::install'],
    notify  => Class['glusterold::service'],
  }

  concat::fragment { 'glusterfsd.vol-header':
    target  => "${glusterold::params::configdir}/glusterfsd.vol",
    order   => 10,
    content => template('glusterold/header.erb')
  }

  # Setup node config file for concat module and include first fragment
  concat { "${glusterold::params::configdir}/glusterfs.vol":
    owner   => 'root',
    group   => 'root',
    require => Class['glusterold::install'],
    notify  => Class['glusterold::service'],
  }

  concat::fragment { 'glusterfs.vol-header':
    target  => "${glusterold::params::configdir}/glusterfs.vol",
    order   => 10,
    content => template('glusterold/header.erb')
  }


}