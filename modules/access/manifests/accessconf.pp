# == Classification: Unclassified (provisional)
#
class access::accessconf {
  $basedir = '/tmp'
  File {
    owner => 'root',
    group => 'root',
    mode  => '0440',
  }
  file { "${basedir}/access.conf.d":
    ensure  => directory,
    source  => 'puppet:///modules/access/access.conf.d',
    purge   => true,
    recurse => true,
  }
  exec { 'rebuild-accessconf':
    command     => "/bin/cat ${basedir}/access.conf.d/* > ${basedir}/access.conf",
    refreshonly => true,
    subscribe   => File["${basedir}/access.conf.d"],
  }
  file { "${basedir}/access.conf":
    require => Exec['rebuild-accessconf'],
  }

  file { '/etc/security/access.conf':
    source  => "${basedir}/access.conf",
    require => Exec['rebuild-accessconf'],
    notify  => Service['sshd']
  }
}
