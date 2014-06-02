# == Classification: Unclassified (provisional)
#
# == Class: sssd
# Manage SSSD authentication on RHEL-based systems.
#
# === Parameters
# [*domains*]
# Required. Array. For each sssd::domain type you declare, you SHOULD also
# include the domain name here. This defines the domain lookup order.
#
# [*filter_users*]
# Optional. Array. Default is 'root'. Exclude specific users from being
# fetched using sssd. This is particularly useful for system accounts.
#
# [*filter_groups*]
# Optional. Array. Default is 'root'. Exclude specific groups from being
# fetched using sssd. This is particularly useful for system accounts.
#
#
# === Requires
# - [ripienaar/concat]
# - [puppetlab/stdlib]
#
# === Example
# class { 'sssd':
#   domains => [ 'uni.adr.unbc.ca' ],
# }
#
# === Authors
# Nicholas Waller <code@nicwaller.com>
#
# === Copyright
# Copyright 2013 Nicholas Waller, unless otherwise noted.
#
class sssd3 (
  $domains,
  $services        = ['nss', 'pam'],
  $filter_users    = [ 'root' ],
  $filter_groups   = [ 'root' ],
  $configtemplate = $sssd3::params::configtemplate,
) inherits sssd3::params {
  validate_array($domains)
  validate_array($filter_users)
  validate_array($filter_groups)
  
  

 anchor {'sssd3::start':} ->class{'sssd3::package':} -> class{'sssd3::config':}
    ~> class{'sssd3::service':} -> anchor{'sssd3::end':}


}
