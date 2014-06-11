# == Classification: Unclassified (provisional)
#
class nfs::params(
  $domain="${::domain}"
) {

  $nfs_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10'  => 'Solaris5.10',
    /Solaris10_u*/ => 'Solaris5.10',
    'Solaris5.11'  => 'Solaris5.11',
    /RedHat5.*/    => 'RedHat5.0',
    /RedHat6.*/    => 'RedHat6.0',
    /CentOS6.*/    => 'RedHat6.0',
    default        => 'UNSUPPORTED',
  }

  if $nfs_conf_ver == 'UNSUPPORTED' {
    fail("Version ${::operatingsystemrelease} of ${::operatingsystem} is not explicitly supported")
  }

  $nfs_cfg_header = "# This file is managed by Puppet.\n# User changes will be destroyed the next time puppet runs.\n"

  case $nfs_conf_ver {
      'Solaris5.10': {
        $nfs_service         = 'nfs/client'
        $nfs_package         = 'SUNWnfscr' 
        $nfs_cfg_location = '/etc/dfs/dfstab'
        $nfs_cfg_template = 'dfstab.erb'
        $nfs_export_cmd   = 'shareall'
        $pkg_provider       = pkgutil
      }
      
      'Solaris5.11': {
        $nfs_service         = 'nfs/client'
        $nfs_package         = 'SUNWnfscr' # TODO is this the correct package?
        $nfs_cfg_location = '/etc/dfs/dfstab' # TODO this needs to be updated for Solaris 11 shares
        $nfs_cfg_template = 'dfstab.erb'
        $nfs_export_cmd   = 'shareall'
        $pkg_provider       = pkgutil
      }
      'RedHat5.0': {
        $nfs_service         = 'nfs'
        $nfs_package         = 'nfs-utils'
        $nfs_cfg_location = '/etc/exports'
        $nfs_cfg_template = 'exports.erb'
        $nfs_export_cmd   = 'exportfs -av'
        $pkg_provider       = yum
      }
      'RedHat6.0': {
        $nfs_service         = 'nfs'
        $nfs_package         = 'nfs-utils'
        $nfs_cfg_location = '/etc/exports'
        $nfs_cfg_template = 'exports.erb'
        $nfs_export_cmd   = 'exportfs -av'
        $pkg_provider       = yum
      }
    }

}
