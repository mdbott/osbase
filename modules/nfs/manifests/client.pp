# == Classification: Unclassified (provisional)
#
class nfs::client(
  $enabled = true
) {
  require nfs::params
  case $nfs::params::nfs_conf_ver {
    'RedHat5.0':   { class {'nfs::redhat50client': } }
    'RedHat6.0':   { class {'nfs::redhat60client': enabled => $enabled,} }
    'Solaris5.10': { class {'nfs::solaris10client': } }
    'UNSUPPORTED': {
      fail("${::operatingsystem}${::operatingsystemrelease} not supported") }
  }

}