# == Classification: Unclassified (provisional)
#
class ldap::redhat50 {

  $ldap_servers  = $ldap::ldap_servers
  $base_dn_array = $ldap::base_dn_array
  $base_dn       = $ldap::base_dn
  $ldap_profile  = $ldap::ldap_profile
  $ldap_cachettl = $ldap::ldap_cachettl
  $domainname    = $ldap::domainname
  $ldap_conf_ver = $ldap::ldap_conf_ver
  $ldap_encrypt  = $ldap::ldapencrypt
  $ldap_uri  = $ldap::ldapuri
  


  file {
    '/etc/openldap/ldap.conf':
      ensure  => present,
      content => template('ldap/etc/openldap/ldap.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Service['nscd'];

    '/etc/ldap.conf':
      ensure  => present,
      content => template('ldap/etc/ldap.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Service['nscd'];

#      '/etc/nslcd.conf':
#      ensure  => present,
#      content => template('ldap/etc/nslcd.conf.erb'),
#      owner   => 'root',
#      group   => 'root',
#      mode    => '0600',
#      notify  => Service['nslcd'];

    #    '/etc/pam.d/password-auth-ac':
#      ensure => present,
#      source => 'puppet:///modules/ldap/etc/pam.d/password-auth-ac',
#      owner  => 'root',
#      group  => 'root',
#      mode   => '0644';

    '/etc/pam_ldap.conf':
      ensure  => present,
      content => template('ldap/etc/pam_ldap.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      # TODO notify => Service[???],
  }

#  service { 'sssd':
#      ensure => 'stopped',
#      enable => 'false',
#      before => Service['nslcd'],
#  }

#  service { 'nslcd':
#      ensure  => 'running',
#      enable  => 'true',
#      require => File['/etc/sysconfig/authconfig'],
#  }

  service { 'nscd':
      ensure  => 'running',
      enable  => 'true',
#      require => File['/etc/sysconfig/authconfig'],
#      require => Service['nslcd'],
  }


#  package { 'nss-pam-ldapd':
#    ensure => present,
#    before => Service['nslcd'],
#  }

  package { 'nscd':
    ensure => present,
    before => Service['nscd'],
  }

#  package { 'sssd':
#   ensure => present,
#   before => Service['sssd'],
#  }

}

