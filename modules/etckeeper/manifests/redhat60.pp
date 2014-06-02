# == Classification: Unclassified (provisional)
#
class etckeeper::redhat60 ($vcs_status_email = undef) {

  package { 'etckeeper':
    ensure => installed,
    before => File['/etc/etckeeper/etckeeper.conf'],
  }

  package { 'mercurial':
    ensure => installed,
    before => File['/etc/etckeeper/etckeeper.conf'],
  }

  file { '/etc/etckeeper/etckeeper.conf':
    source  => 'puppet:///modules/etckeeper/etckeeper.conf-hg',
    owner   => 'root',
    group   => 'root',
  }

  exec { 'etckeeper-init':
    command => 'etckeeper init',
    unless  => 'etckeeper vcs identify',
  }

  # replace stock buggy (in RHEL6.3 at least, see file)
  # this is a bit sketchy as this file isn't listed as a conf file, so during upgrades our copy may
  # get messed around with, not a huge deal - at worst we'll notice when the fix comes in
  file { '/etc/cron.daily/etckeeper':
    source  => 'puppet:///modules/etckeeper/etc_cron.daily_etckeeper',
    require => [Package['etckeeper'],Package['mercurial']],
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  if $vcs_status_email {
    $status_ensure = present
  } else {
    $status_ensure = absent
  }

  file {'/etc/cron.daily/00etckeeper-status-email':
    ensure  => $status_ensure,
    require => [Package['etckeeper'],Package['mercurial']],
    content => template('etckeeper/etc_cron.daily_00etckeeper-status-email.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }


}
