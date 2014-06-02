# == Classification: Unclassified (provisional)
#
class dns3::package{

  package { 'resolver package':
    ensure => present,
    name   => $dns3::params::packagename,
  }

}
