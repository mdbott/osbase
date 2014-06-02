# == Classification: Unclassified (provisional)
#
class nscd::package{

  package { 'nscd package':
    ensure => present,
    name   => $nscd::params::packagename,
  }

}