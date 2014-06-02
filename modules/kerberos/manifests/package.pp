# == Classification: Unclassified (provisional)
#
class kerberos::package{

  package { $kerberos::params::packagename:
    ensure => present
  }

}