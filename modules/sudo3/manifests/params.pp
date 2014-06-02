# == Classification: Unclassified (provisional)
#
# == Class: sudo3::params
#
# Sets base parameters
#
# === Parameters
#
# [*packagename*]
# Defines OS specific package name
#
# [*package_provider*]
# Defines OS specific package provider
#
# [*configfile*]
# Defines the path of sudoers file
#
# [*configtemplate*]
# Specifies the template to use for the sudoers file
#
# [*sudo_conf_version*]
# Specifes the OS release
#
# [*fragment_dir*]
# Specifies the location/path for the diectory holding the custom user/group/netgroup entires
#
#
# === Examples
#
# inherits sudo3::params
#
# === Hiera
#
# Not applicable
#
# === Variables
#
# Not applicable
#
# === Templates
#
# Not applicable
#
# === Maintainers
#
# UPS
#
class sudo3::params {

  $sudo_conf_version = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10'     => 'Solaris',
    /Solaris10_u*/    => 'Solaris',
    'Solaris5.11'     => 'Solaris',
    /RedHat5\.[5-9]/  => 'RedHat',
    /RedHat6.*/       => 'RedHat',
    /CentOS6.*/       => 'RedHat',
    default           => fail("Version of ${::operatingsystem} is not explicitly supported by sudo module")
  }

  $configtemplate = 'sudo3/sudoers.erb'
  case $sudo_conf_version {
    'Solaris': {
      $packagename = 'CSWsudo'
      $package_provider = 'pkgutil'
      $configfile = '/opt/csw/etc/sudoers'
      $configfile2 = '/etc/opt/csw/sudoers'
    }
    'RedHat': {
      $packagename = 'sudo'
      $package_provider = 'yum'
      $configfile = '/etc/sudoers'
    }
  }
  $fragment_dir   = "${configfile}.d"
         
}
