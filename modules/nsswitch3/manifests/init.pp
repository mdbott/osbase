# == Classification: Unclassified (provisional)
#
# == Class: nsswitch3
#
# Sets up name services in /etc/nsswitch.conf depending on environment
#
# === Version
#
# 1.0
#
# == Parameters
# [*aliases*]
#  Array of databases to use for the service
# [*automount*]
#  Array of databases to use for the service
# [*bootparams*]
#  Array of databases to use for the service
# [*ethers*]
#  Array of databases to use for the service
# [*group*]
#  Array of databases to use for the service
# [*hosts*]
#  Array of databases to use for the service
# [*netgroup*]
#  Array of databases to use for the service
# [*netmasks*]
#  Array of databases to use for the service
# [*network*]
#  Array of databases to use for the service
# [*passwd*]
#  Array of databases to use for the service
# [*protocols*]
#  Array of databases to use for the service
# [*publickey*]
#  Array of databases to use for the service
# [*rpc*]
#  Array of databases to use for the service
# [*services*]
#  Array of databases to use for the service
# [*shadow*]
#  Array of databases to use for the service
# [*sudoers*]
#  Array of databases to use for the service
#
# === Hiera
#
# [*auth*]
# System authentication method - 'local', 'ldap', 'sss', 'vas', 'winbind'.  Default is 'local'
#
# [*nsswitch3::<service>*]
#   Array of databases to use for the service - 'files', 'ldap' etc.
#
# === Examples
#
# Node definitions
#
# include nsswitch3
#
# Hiera values
#
# auth: ldap
# nsswitch3::bootparams:
#   - nisplus
#   - files
# nsswitch3::sudoers: 
#   - sss
#
# === Maintainers
#
# UPS
#
class nsswitch3 (
          $aliases        = $nsswitch3::params::aliases,
          $auth_attr      = $nsswitch3::params::auth_attr,
          $automount      = $nsswitch3::params::automount,
          $bootparams     = $nsswitch3::params::bootparams,
          $ethers         = $nsswitch3::params::ethers,
          $group          = $nsswitch3::params::group,
          $hosts          = $nsswitch3::params::hosts,
          $ipnodes        = $nsswitch3::params::ipnodes,
          $netgroup       = $nsswitch3::params::netgroup,
          $netmasks       = $nsswitch3::params::netmasks,
          $network        = $nsswitch3::params::network,
          $passwd         = $nsswitch3::params::passwd,
          $printers       = $nsswitch3::params::printers,
          $prof_attr      = $nsswitch3::params::prof_attr,
          $project        = $nsswitch3::params::project,
          $protocols      = $nsswitch3::params::protocols,
          $publickey      = $nsswitch3::params::publickey,
          $rpc            = $nsswitch3::params::rpc,
          $sendmailvars   = $nsswitch3::params::sendmailvars,
          $services       = $nsswitch3::params::services,
          $shadow         = $nsswitch3::params::shadow,
          $sudoers        = $nsswitch3::params::sudoers,
          $tnrhdb         = $nsswitch3::params::tnrhdb,
          $tnrhtp         = $nsswitch3::params::tnrhtp,
          $configtemplate = $nsswitch3::params::configtemplate
) inherits nsswitch3::params {

  anchor {'nsswitch3::start':} -> class{'nsswitch3::config':} -> anchor{'nsswitch3::end':}


}
