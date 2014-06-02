# == Classification: Unclassified (provisional)
#
class winbind::redhat60 {
  package { 'samba4-winbind':
    ensure => present,
  }
  package { 'samba4-winbind-clients':
    ensure => present,
  }
  package { 'oddjob-mkhomedir':
    ensure  => present,
  }

  file {

    '/etc/krb5.conf':
      ensure => present,
      content => template('winbind/etc/krb5/krb5.conf.erb'),
      owner  => 'root',
      group  => 'sys',
      mode   => '0644',
      before => Exec['netjoin'];

    '/etc/samba/smb.conf':
      ensure => present,
      content => template('winbind/etc/samba/smb.conf-RedHat6.0.erb'),
      owner  => 'root',
      group  => 'sys',
      mode   => '0644',
      require => Package['samba4-winbind'],
      before => Exec['netjoin'];
  }

  service { 'winbind':
      ensure  => 'running',
      enable  => 'true',
      require => File['/etc/samba/smb.conf'],
  }

  exec { 'netjoin':
    command => "/usr/bin/net ads join -U ${winbind::adusername}%${winbind::adpassword}",
    creates => "/var/lib/samba/private/secrets.tdb",
    require => Package['samba4-winbind'],
    notify => Service['winbind'],
  }

  service { 'oddjobd':
     ensure  => 'running',
     enable  => true,
     require => Package['oddjob-mkhomedir'],
  }
}

