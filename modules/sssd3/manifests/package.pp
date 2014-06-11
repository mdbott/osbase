# == Classification: Unclassified (provisional)
#
class sssd3::package {
  
  package { $sssd3::params::packagename:
    ensure => present,
  }
}
