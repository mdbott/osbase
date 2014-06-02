# == Classification: Unclassified (provisional)
#
class mkhomedir3::package {
  if $mkhomedir3::params::packagename != '' {
      package { $mkhomedir3::params::packagename:
        ensure => installed,
      }
  }

}
