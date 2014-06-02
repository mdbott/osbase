# == Classification: Unclassified (provisional)
#
class xymon::params {

  $xymon_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10'     => 'Solaris',
    /Solaris10_u*/   => 'Solaris',
    'Solaris5.11'     => 'Solaris',
    /RedHat5\.[5-9]/  => 'RedHat',
    'RedHat5.10'      => 'RedHat',
    /RedHat6.*/       => 'RedHat',
    /CentOS6.*/       => 'RedHat',
    default           => fail("Version ${::operatingsystemrelease} of ${::operatingsystem} is not explicitly supported"),
  }

  if $::operatingsystem == 'RedHat' and $::operatingsystemrelease =~ /6.*/ and $::architecture != 'x86_64' { fail('Non-x86_64 is unsupported') }
  $puppet_summary_location = '/var/lib/puppet/state/last_run_summary.yaml'

  case $xymon_conf_ver {

    'Solaris': {
      $xymon_ensure                 = 'present'
      $xymon_pkg                    = 'CSWhobbitc'
      $xymon_service                = 'xymon'
      $xymon_home                   = '/opt/csw/libexec/hobbit/client'
      $xymon_cfg_location           = "${xymon_home}/etc/hobbitclient.cfg"
      $xymon_clientlaunch_location  = "${xymon_home}/etc/clientlaunch.cfg"
      $xymon_clientlaunchd_location = "${xymon_home}/etc/clientlaunch.d"
      $xymon_log_file_base          = "${xymon_home}/logs"
      $xymon_owner                  = 'hobbit'
      $xymon_group                  = 'hobbit'
      $pkg_provider                 = pkgutil
    }

    'RedHat': {
      $xymon_ensure                 = '4.3.7-1'
      $xymon_pkg                    = 'xymon-client'
      $xymon_service                = 'xymon-clientd'
      $xymon_home                   = '/opt/xymon/client'
      $xymon_cfg_location           = "${xymon_home}/etc/xymonclient.cfg"
      $xymon_clientlaunch_location  = "${xymon_home}/etc/clientlaunch.cfg"
      $xymon_clientlaunchd_location = "${xymon_home}/etc/clientlaunch.d"
      $xymon_log_file_base          = "${xymon_home}/logs"
      $xymon_owner                  = 'xymon'
      $xymon_group                  = 'daemon'
      $pkg_provider                 = yum
    }
  }
}
