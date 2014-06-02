# == Classification: Unclassified (provisional)
#
class winbind::redhat50 {

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
      content => template('winbind/etc/samba/smb.conf-RedHat5.0.erb'),
      owner  => 'root',
      group  => 'sys',
      mode   => '0644',
      require => Package['samba3x-winbind'],
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
    require => Package['samba3x-winbind'],
    notify => Service['winbind'],
  }

  package { 'samba3x-winbind':
    ensure => present,
  }
  package { 'samba3x-client':
    ensure => present,
  }

}

