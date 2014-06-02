# == Classification: Unclassified (provisional)
#
class sshd3::package {
  package { $sshd3::params::packagename:
    ensure => installed,
  }
}
