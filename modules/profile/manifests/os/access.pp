# == Classification: Unclassified (provisional)
#
# == Class: profile::os::access
#
# Manages the access configuration on Solaris 10 & RHEL-based systems.
#
#
# === Examples
#
#  class { 'profile::os::access':  }
#
# === Authors
#
# Max Bott <mdbott@dsd.defence.gov.au>
#
# === Copyright
#
# Copyright 2014 Max Bott
#
class profile::os::access(
  $supportnetgroup = 'role-unix-support',
  $accessnetgroup = undef,
  $supportgroup = undef
) {
  class {'pkg_management': stage => pre4 }
  include access3
  include sudo3
  
  $accountsource = hiera("profile::os::base::accountsource","local")
  case $accountsource {
      local: { 
        class {'admin_users3':            }
        include configpuppet::facts
        include configpuppet::owner_facts
      }
      ldap: { 
        sudo3::netgroup { $supportnetgroup: ensure   => present,commands => ['ALL'],}
        if $accessnetgroup {
          access3::allowgroup { $accessnetgroup:        ensure => present}
        } else {
          access3::allowgroup { "access-${::fqdn}":     ensure => present}
        }
        
      }
      ad: {
        if $profile::os::access::supportgroup {
            access3::allowuser { $supportgroup:        ensure => present}
            sudo3::group { $supportgroup: ensure => present}
        }
        
      }
      ipa: {}
      default: {
        fail("Unsupported Account Source: ${accountsource}")
      }
  }
  
}