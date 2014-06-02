# == Classification: Unclassified (provisional)
#
class keepalived::params {

  $keepalived_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    /^RedHat6[.][0-9]$/   => 'RedHat6.0',
    default       => 'UNSUPPORTED',
  }

  if $keepalived_conf_ver == 'UNSUPPORTED' {
    fail("Version ${::operatingsystemrelease} of ${::operatingsystem} is not explicitly supported")
  }

  case $keepalived_conf_ver {
      'RedHat6.0': {
        $keepalived_pkg = 'keepalived'
        $keepalived_service = 'keepalived'
        $keepalived_cfg_location = '/etc/keepalived/keepalived.conf'
        $pkg_provider       = yum
      }
    }

}
