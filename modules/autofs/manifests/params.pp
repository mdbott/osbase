# == Classification: Unclassified (provisional)
class autofs::params {
  $autofs_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10'  => 'Solaris5.10',
    /Solaris10_u*/ => 'Solaris5.10',
    /RedHat5.*/    => 'RedHat5.0',
    /RedHat6.*/    => 'RedHat6.0',
    /CentOS6.*/    => 'RedHat6.0',
    default        => 'UNSUPPORTED'
  }

  if $autofs_conf_ver == 'UNSUPPORTED' {
    fail("Version ${::operatingsystemrelease} of ${::operatingsystem} is not explicitly supported")
  }

  case $autofs_conf_ver {
    'Solaris5.10': {
      $autofs_package      = 'SUNWatfsr'
      $autofs_service      = 'filesystem/autofs'
      $automaster_file     = 'auto_master'
      $automaster_file_grp = 'bin'
    }
    'RedHat5.0': {
      $autofs_package      = 'autofs'
      $autofs_service      = 'autofs'
      $automaster_file     = 'auto.master'
      $automaster_file_grp = 'root'
    }
    'RedHat6.0': {
      $autofs_package      = 'autofs'
      $autofs_service      = 'autofs'
      $automaster_file     = 'auto.master'
      $automaster_file_grp = 'root'
    }
  }
}
