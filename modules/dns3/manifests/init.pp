# == Classification: Unclassified (provisional)
#
# == Class: dns
#
# Sets up DNS servers in /etc/resolv.conf depending on environment
#
# === Parameters
#
# [*nameservers*]
#  Comma separated list of DNS servers to use
#
# [*dnssearchpath*]
#  Default DNS search path to set
#
# [*configtemplate*]
#  Default DNS search path to set
#
# === Hiera
#
# [*dns3::nameservers*]
#   Comma separated list of DNS servers to use
#
# [*dns3::dnssearchpath*]
#   Default DNS search path to set
#
# === Examples
#
# include dns3
#
# === Maintainers
#
# UPS
#
class dns3(
  $nameservers,
  $dnssearchpath,
  $configtemplate = $dns3::params::configtemplate
) inherits dns3::params {

  anchor {'dns3::start':} ->class{'dns3::package':} -> class{'dns3::config':}
    ~> class{'dns3::service':} -> anchor{'dns3::end':}

}
