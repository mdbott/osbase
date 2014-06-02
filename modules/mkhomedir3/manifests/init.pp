# == Classification: Unclassified (provisional)
#
# == Class: mkhomedir3
#
# Sets up automatic home directory creation depending on environment
#
# === Parameters
#
# === Hiera
#
#
# === Examples
#
# include mkhomedir3
#
# === Maintainers
#
# UPS
#
class mkhomedir3 inherits mkhomedir3::params {

  anchor {'mkhomedir3::start':} ->class{'mkhomedir3::package':} -> class{'mkhomedir3::config':}
    ~> class{'mkhomedir3::service':} -> anchor{'mkhomedir3::end':}
}
