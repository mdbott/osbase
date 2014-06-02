# == Classification: Unclassified (provisional)
#
class nfs::server(
  $enabled = true
)   {
  require nfs::params
  Class['nfs::client'] -> Class['nfs::server']

  case $nfs::params::nfs_conf_ver {
    'RedHat5.0':   { class {'nfs::redhat50server': } }
    'RedHat6.0':   { class {'nfs::redhat60server': enabled => $enabled,} }
    'Solaris5.10': { class {'nfs::solaris10server': } }
    'UNSUPPORTED': {
      fail("${::operatingsystem}${::operatingsystemrelease} not supported") }
  }

}