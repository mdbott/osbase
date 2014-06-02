# == Classification: Unclassified (provisional)
#
class mkhomedir3::service{
  include mkhomedir3::params
  if $mkhomedir3::params::servicename != '' {
      service { $mkhomedir3::params::servicename:
        ensure  => 'running',
        enable  => true,
      }
  }
}