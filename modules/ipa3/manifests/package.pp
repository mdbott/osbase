# == Classification: Unclassified (provisional)
#
class ipa3::package {
  package { $ipa3::params::packagename:
    ensure => installed,
  }
}
