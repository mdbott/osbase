# == Classification: Unclassified (provisional)
#
class glusterold::params {

  $gluster_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'RedHat5.6'   => 'RedHat5.0',
    /^RedHat6[.][0-9]$/   => 'RedHat6.0',
    default       => 'UNSUPPORTED',
  }

  if $gluster_conf_ver == 'UNSUPPORTED' {
    fail("Version ${::operatingsystemrelease} of ${::operatingsystem} is not explicitly supported")
  }



  case $gluster_conf_ver {
      'RedHat6.0': {
        $gluster_pkg = 'glusterfs-server'
        $gluster_fuse_pkg = 'glusterfs-fuse'
        $gluster_service = 'glusterd'
        $configdir = '/etc/glusterfs'
        $pkg_provider       = yum
      }
    }

}
