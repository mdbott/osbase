# == Classification: Unclassified (provisional)
#
class winbind3::params {
  $winbind3_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10' => 'Solaris10',
    /Solaris10_u*/=> 'Solaris10',
    'Solaris5.11' => 'Solaris11',
    /Solaris11_u*/=> 'Solaris11',
    /RedHat5.*/   => 'RedHat5.0',
    /RedHat6.*/   => 'RedHat6.0',
    /CentOS6.*/   => 'RedHat6.0',
    default       => fail("${::operatingsystem}${::operatingsystemrelease} is not supported"),
  }

  case $winbind3_conf_ver {
    'Solaris11': {
       $packagename    = [ 'SUNWsmbau' ]
       $configfile     = '/etc/sfw/smb.conf'
       $configtemplate = 'winbind3/sshd_config.Solaris5.11.erb'
       $netjoincmd     = '/usr/sfw/bin/net'
       $secretsfile    = '/etc/sfw/private/secrets.tdb'
       $servicename    = 'network/ssh'
    }
     'Solaris10': {
       $packagename    = [ 'SUNWsmbau' ]
       $configfile     = '/etc/sfw/smb.conf'
       $configtemplate = 'winbind3/sshd_config.Solaris5.10.erb'
       $netjoincmd     = '/usr/sfw/bin/net'
       $secretsfile    = '/etc/sfw/private/secrets.tdb'
       $servicename    = 'network/ssh'
    }
    'RedHat5.0': {
      $packagename    = ['samba3x-winbind', 'samba3x-client']
      $configfile     = '/etc/samba/smb.conf'
      $configtemplate = 'winbind3/sshd_config.RedHat5.0.erb'
      $netjoincmd     = '/usr/bin/net'
      $secretsfile    = '/var/lib/samba/private/secrets.tdb'
      $servicename    = 'winbind'
    }
    'RedHat6.0': {
      $packagename    = ['samba4-winbind', 'samba4-winbind-clients']
      $configfile     = '/etc/samba/smb.conf'
      $configtemplate = 'winbind3/sshd_config.RedHat6.0.erb'
      $netjoincmd     = '/usr/bin/net'
      $secretsfile    = '/var/lib/samba/private/secrets.tdb'
      $servicename    = 'winbind'
    }
  }

}
