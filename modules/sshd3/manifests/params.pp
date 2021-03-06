# == Classification: Unclassified (provisional)
#
class sshd3::params {
  $sshd3_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10' => 'Solaris10',
    /Solaris10_u*/=> 'Solaris10',
    'Solaris5.11' => 'Solaris11',
    /Solaris11_u*/=> 'Solaris11',
    /RedHat5.*/   => 'RedHat5.0',
    /RedHat6.*/   => 'RedHat6.0',
    /CentOS6.*/   => 'RedHat6.0',
    default       => fail("${::operatingsystem}${::operatingsystemrelease} is not supported"),
  }

  case $sshd3_conf_ver {
    'Solaris11': {
       $packagename    = [ 'SUNWsshcu', 'SUNWsshdr', 'SUNWsshdu', 'SUNWsshr', 'SUNWsshu' ]
       $configtemplate = 'sshd3/sshd_config.Solaris5.11.erb'
       $servicename    = 'network/ssh'
    }
     'Solaris10': {
       $packagename    = [ 'SUNWsshcu', 'SUNWsshdr', 'SUNWsshdu', 'SUNWsshr', 'SUNWsshu' ]
       $configtemplate = 'sshd3/sshd_config.Solaris5.10.erb'
       $servicename    = 'network/ssh'
    }
    'RedHat5.0': {
      $packagename    = ['openssh', 'openssh-clients', 'openssh-server']
      $configtemplate = 'sshd3/sshd_config.RedHat5.0.erb'
      $servicename    = 'sshd'
    }
    'RedHat6.0': {
      $packagename    = ['openssh', 'openssh-clients', 'openssh-server']
      $configtemplate = 'sshd3/sshd_config.RedHat6.0.erb'
      $servicename    = 'sshd'
    }
  }

}
