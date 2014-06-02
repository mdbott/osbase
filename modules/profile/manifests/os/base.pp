# == Classification: Unclassified (provisional)
#
# == Class: profile::os::base
#
# Manages the Base operating system configuration on Solaris 10 & RHEL-based systems.
#
# === Parameters
#
# [*accountsource*]
# Required. String. Specifies the source of account information for the system. Can be either
# "local", "ldap", "ad", "vas" or "ipa". This would usually be specified via hiera
#
# [*homedirsource*]
# Required. String. Specifies the location/method of provisioning a homedir to users
# on the system. Can be either "local", "autofs" or "oddjob". This would usually be 
# specified via hiera
#
#
# === Examples
#
#  class { 'profile::os::base': accountsource => 'ldap', homedirsource => 'autofs' }
#
# === Authors
#
# Max Bott <mdbott@dsd.defence.gov.au>
#
# === Copyright
#
# Copyright 2014 Max Bott
#
class profile::os::base(
  $accountsource,
  $homedirsource
) {
  include stages
  class {'dns3':            stage => pre4}
  class {'policy':          stage => pre4}
  include ntp
  include sshd3
  class {'nsswitch3':       stage => pre4}
  class {'pam3':             }
  class {"profile::os::$accountsource":  }
  if $homedirsource != "local" {
    class {"$homedirsource":  }
  }
  include configpuppet::facts
  include configpuppet::owner_facts
}