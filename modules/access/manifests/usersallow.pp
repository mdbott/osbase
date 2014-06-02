# == Classification: Unclassified (provisional)

class access::usersallow($manageusers = true) {
  $basedir = '/tmp'
  File {
    owner => 'root',
    group => 'root',
    mode  => '0440',
  }
  file { "${basedir}/users.allow.d":
    ensure  => directory,
    source  => 'puppet:///modules/access/users.allow.d',
    purge   => true,
    recurse => true,
  }
  exec { 'rebuild-usersallow':
    command     => "/bin/cat ${basedir}/users.allow.d/* > ${basedir}/users.allow",
    refreshonly => true,
    subscribe   => File["${basedir}/users.allow.d"],
  }
  file { "${basedir}/users.allow":
    require => Exec['rebuild-usersallow'],
  }
  if $manageusers == true {
    file { '/etc/users.allow':
      source  => "${basedir}/users.allow",
      require => Exec['rebuild-usersallow'],
      notify  => Service['sshd']
    }
  } else {
    file { '/etc/users.allow':
      ensure => present
    }
  }
  
}