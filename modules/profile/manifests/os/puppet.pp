# == Classification: Unclassified (provisional)
#
# == Class: profile::os::puppet
#
# Manages the puppet configuration on Solaris 10 & RHEL-based systems.
#
# === Parameters
#
#
#
# === Examples
#
#  class { 'profile::os::puppet':  }
#
# === Authors
#
# Max Bott <mdbott@dsd.defence.gov.au>
#
# === Copyright
#
# Copyright 2014 Max Bott
#
class profile::os::puppet {
  include configpuppet
}