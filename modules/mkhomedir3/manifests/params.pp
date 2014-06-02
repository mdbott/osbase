# == Classification: Unclassified (provisional)
#
class mkhomedir3::params {
  $mkhomedir3_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10' => 'Solaris10',
    /Solaris10_u*/=> 'Solaris10',
    'Solaris5.11' => 'Solaris11',
    /Solaris11_u*/=> 'Solaris11',
    /RedHat5.*/   => 'RedHat5.0',
    /RedHat6.*/   => 'RedHat6.0',
    /CentOS6.*/   => 'RedHat6.0',
    default       => fail("${::operatingsystem}${::operatingsystemrelease} is not supported"),
  }

  case $mkhomedir3_conf_ver {
    'Solaris11': {
       $packagename    = ''
       $configtemplate = 'mkhomedir3/auto_home.erb'
       $servicename    = ''
    }
     'Solaris10': {
       $packagename    = ''
       $configtemplate = 'mkhomedir3/auto_home.erb'
       $servicename    = ''
    }
    'RedHat5.0': {
      $packagename    = 'oddjob-mkhomedir'
      $servicename    = 'oddjobd'
    }
    'RedHat6.0': {
      $packagename    = 'oddjob-mkhomedir'
      $servicename    = 'oddjobd'
    }
  }

}
