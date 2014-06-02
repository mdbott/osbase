# == Classification: Unclassified (provisional)
#
class samba3::package {
  package { $samba3::params::packagename:
    ensure => installed,
  }
}
