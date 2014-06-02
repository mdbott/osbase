# == Classification: Unclassified (provisional)
#
# == Class: nslcd
#
# Manage the name service ldap configuration daemon on  RHEL-based systems.
#
# === Parameters
#
# [*servers*]
# Required. Array. Specifices the list of ldapservers that will be contacted for 
# the nslcd process
#
# [*basedn*]
# Required. String. Specifices the base DN of the ldapservers that will be contacted for 
# the nslcd process
#
# [*ldapuri*]
# Required. String. Specifices the ldap url prefix for the ldapserver. Could be either
# "ldap://" or "ldaps://"
#
# === Examples
#
#  class { nslcd:
#    servers => [ 'ldap1.example.org', 'ldap2.example.org' ],
#    basedn  => 'ou=example,ou=org,c=au',
#    ldapuri => 'ldap://'
#  }
#
# === Authors
#
# Max Bott <mdbott@dsd.defence.gov.au>
#
# === Copyright
#
# Copyright 2014 Max Bott
#
class nslcd(
  $servers,
  $basedn,
  $ldapuri
) inherits nslcd::params {

  anchor {'nslcd::start':} ->class{'nslcd::package':} -> class{'nslcd::config':}
    ~> class{'nslcd::service':} -> anchor{'nslcd::end':}
}
