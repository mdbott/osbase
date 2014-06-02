# == Classification: Unclassified (provisional)
#
class salt::server inherits salt::params {

  package { $salt_server_pkg:
    ensure => installed,
    before => Service[$salt_server_srv],
  }

  service { $salt_server_srv:
    ensure  => running,
    enable  => true,
  }

}
