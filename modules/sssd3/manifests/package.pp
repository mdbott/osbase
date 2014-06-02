# == Classification: Unclassified (provisional)
#
class sssd3::package {
  
  package { 'sssd':
    ensure => present,
    name   => $sssd3::params::packagename,
  }
}