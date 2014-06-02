# == Classification: Unclassified (provisional)
#
class winbind3::package {
  include winbind3::params
  package { $winbind3::params::packagename:
    ensure => installed,
  }
}
