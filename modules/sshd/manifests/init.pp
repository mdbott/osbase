# == Classification: Unclassified (provisional)
# == Class: sshd
#
# Installs and enables sshd
#
# == Future Directions
#
#
# == Parameters
#
#
# == Variables
#
#
# == Extlookup
#
# [*sshrootlogin*]
#   'no' complies with ISM 2012 control 0484 (compliance:should)
# [*sshtcpforward*]
#   'no' complies with ISM 2012 control 0484 (compliance:should)
# [*sshx11forward*]
#   'no' complies with ISM 2012 control 0484 (compliance:should)
#
# == Examples
#
#   include sshd
#
# == Maintainers
#
# SSU
#
class sshd {

  if $::operatingsystem == 'Solaris' {
    $sshd_pkg_names = [ 'SUNWsshcu', 'SUNWsshdr', 'SUNWsshdu', 'SUNWsshr', 'SUNWsshu' ]
    $sshd_service_name = 'network/ssh'
  } elsif $::operatingsystem == 'RedHat' or  $::operatingsystem == 'CentOS' {
    $sshd_pkg_names = ['openssh', 'openssh-clients', 'openssh-server']
    $sshd_service_name = 'sshd'
  } else {
    fail("Operating system not supported")
  }

  $sshd_config_version = "${::operatingsystem}${::operatingsystemrelease}" ? {
    /Solaris10_u*/ => 'Solaris5.10',
    'Solaris5.10'  => 'Solaris5.10',
    'Solaris5.11'  => 'Solaris5.11',
    /RedHat5.*/    => 'RedHat5.0',
    /RedHat6.*/    => 'RedHat6.0',
    /CentOS6.*/    => 'RedHat6.0',
    default        => 'UNSUPPORTED'
  }

  if $sshd_config_version == 'UNSUPPORTED' {
    fail("Version ${::operatingsystemrelease} of ${::operatingsystem} is not explicitly supported")
  }

  $sshrootlogin   = extlookup("sshrootlogin")
  $sshtcpforward  = extlookup("sshtcpforward")
  $sshx11forward  = extlookup("sshx11forward")


  package { $sshd_pkg_names:
    ensure => installed,
  }

  file { '/etc/ssh/sshd_config':
    ensure  => file,
    content => template("sshd/sshd_config.${sshd_config_version}.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    notify  => Service['sshd'],
    require => Package[$sshd_pkg_names],
  }

  service { 'sshd':
    ensure     => running,
    name       => $sshd_service_name,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
