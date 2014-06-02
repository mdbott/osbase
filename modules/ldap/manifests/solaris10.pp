# == Classification: Unclassified (provisional)
#
class ldap::solaris10 {

  $ldap_servers       = $ldap::ldap_servers
  $ldap_bindpassword  = $ldap::ldap_bindpassword
  $base_dn_array      = $ldap::base_dn_array
  $base_dn            = $ldap::base_dn
  $ldap_profile       = $ldap::ldap_profile
  $ldap_cachettl      = $ldap::ldap_cachettl
  $domainname         = $ldap::domainname
  $ldap_encrypt  = $ldap::ldapencrypt
  $ldap_uri  = $ldap::ldapuri
  


  package { 'SUNWnisu':
    ensure => installed,
  }

  service { 'svc:/network/ldap/client:default':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  file {
    '/etc/krb5/krb5.conf':
      ensure => present,
      source => 'puppet:///modules/ldap/etc/krb5/krb5.conf',
      owner  => 'root',
      group  => 'sys',
      mode   => '0644';

    '/etc/defaultdomain':
      ensure  => present,
      content => template('ldap/etc/defaultdomain.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644';

    '/var/ldap/ldap_client_cred':
      ensure  => present,
      content => template('ldap/var/ldap/ldap_client_cred.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0400',
      notify  => Service['svc:/network/ldap/client:default'];

    '/var/ldap/ldap_client_file':
      ensure  => present,
      content => template('ldap/var/ldap/ldap_client_file.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0400',
      notify  => Service['svc:/network/ldap/client:default'];
  }

}
