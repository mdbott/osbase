# == Classification: Unclassified (provisional)
#
class winbind::solaris10 {



  file {

    '/etc/krb5/krb5.conf':
      ensure => present,
      content => template('winbind/etc/krb5/krb5.conf.erb'),
      owner  => 'root',
      group  => 'sys',
      mode   => '0644';

    '/etc/sfw/smb.conf':
      ensure => present,
      content => template('winbind/etc/samba/smb.conf-Solaris10.erb'),
      owner  => 'root',
      group  => 'sys',
      mode   => '0644',
      require => Package['SUNWsmbau'];
  }

  service { 'name-service-cache':
      ensure  => 'stopped',
      enable  => false,
      before => Service['winbind'],
  }

  service { 'winbind':
      ensure  => 'running',
      enable  => true,
      require => File['/etc/sfw/smb.conf'],
  }

  exec { 'netjoin':
    command => "/usr/sfw/bin/net ads join -U ${winbind::adusername}%${winbind::adpassword}",
    creates => "/etc/sfw/private/secrets.tdb",
    require => Package['SUNWsmbau'],
    notify => Service['winbind'],
    before => Service['winbind'];
  }


  package { 'SUNWsmbau':
    ensure => present,
  }



}
