# == Classification: Unclassified (provisional)
class sudo::params {

  $sudo_conf_version = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10'  => 'Solaris',
    /Solaris10_u*/ => 'Solaris',
    'Solaris5.11'  => 'Solaris',
    /RedHat5.*/    => 'RedHat',
    /RedHat6.*/    => 'RedHat',
    /CentOS6.*/    => 'RedHat',
    default        => fail("Version of ${::operatingsystem} is not explicitly supported by sudo module")
  }

  case $sudo_conf_version {
      'Solaris': {
        $sudo_package = 'CSWsudo'
        $sudo_provider = 'pkgutil'
        $sudo_configfile = '/opt/csw/etc/sudoers'
        $sudo_configfile2 = '/etc/opt/csw/sudoers'
      }
      'RedHat': {
        $sudo_package = 'sudo'
        $sudo_provider = 'yum'
        $sudo_configfile = '/etc/sudoers'
      }
    }

    $fragment_dir = "${sudo_configfile}.d"
    
}
