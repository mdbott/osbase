# == Classification: Unclassified (provisional)
#
class dns3::params{

  $dns3_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10'    => 'Solaris10',
    /Solaris10_u*/   => 'Solaris10',
    'Solaris5.11'    => 'Solaris11',
    /Solaris11_u*/   => 'Solaris11',
    /RedHat5\.[5-9]/ => 'RedHat',
    /RedHat6.*/      => 'RedHat',
    /CentOS6.*/      => 'RedHat',
    default          => fail("${::operatingsystem}${::operatingsystemrelease} is not supported"),
  }

  case $dns3_conf_ver {
    'Solaris11': {
       $packagename    = 'SUNWcslr'
       $configtemplate = 'dns3/resolv.conf.Solaris5.11.erb'
    }
     'Solaris10': {
       $packagename    = 'SUNWcslr'
       $configtemplate = 'dns3/resolv.conf.erb'
    }
    'RedHat': {
      $packagename    = 'glibc'
      $configtemplate = 'dns3/resolv.conf.erb'
    }
  }

}
