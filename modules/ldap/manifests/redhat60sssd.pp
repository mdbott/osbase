# == Classification: Unclassified (provisional)
#
class ldap::redhat60sssd {

  $ldap_servers  = $ldap::ldap_servers
  $base_dn_array = $ldap::base_dn_array
  $base_dn       = $ldap::base_dn
  $ldap_profile  = $ldap::ldap_profile
  $ldap_cachettl = $ldap::ldap_cachettl
  $domainname    = $ldap::domainname
  $ldap_conf_ver = $ldap::ldap_conf_ver
  $ldap_encrypt  = $ldap::ldapencrypt
  $ldap_uri      = $ldap::ldapuri
  $ldap_certname = $ldap::ldapcertname
  $ldap_servertype = $ldap::ldapservertype
  $ldap_homedir  = $ldap::ldaphomedir
  
  case $ldap_servertype {
    'Solaris':  { 
                  $ldap_group_container     = 'group'
                  $ldap_netgroup_container  = 'netgroup'
                }
    'Redhat':  { 
                  $ldap_group_container     = 'groups'
                  $ldap_netgroup_container  = 'netgroups'
                }

  }

  $sssd_ensure      = extlookup("sssd_ensure","present")
  if extlookup("fallback_to_local_users","false") == 'true' {
      $fallback_to_local_users = 'true'
  }

  file {
    '/etc/openldap/ldap.conf':
      ensure  => present,
      content => template('ldap/etc/openldap/ldap.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644';

    '/etc/sssd':
      ensure  => directory,
      owner   => 'root',
      mode    => '0600',
      before  => Service['sssd'];

    '/etc/sssd/sssd.conf':
      ensure  => present,
      content => template('ldap/etc/sssd/sssd.conf.erb'),
      owner   => 'root',
      mode    => '0600',
      before  => Service['sssd'],
      notify  => Service['sssd'];

    '/etc/nscd.conf':
      ensure  => present,
      content => template('ldap/etc/nscd.conf-sssd.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644';

    '/etc/nslcd.conf':
      ensure  => absent;

  }
  if $ldap_encrypt == 'yes' {
    file { '/etc/openldap/cacerts':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '755',
    }

    file { "/etc/openldap/cacerts/${ldap_certname}":
      ensure  => 'file',
      source => "puppet:///modules/ldap/${ldap_certname}",
      owner  => 'root',
      group   => 'root',
      mode    => '644',
      require => File['/etc/openldap/cacerts'] 
    }
    exec {'create key hash':
      command => "/bin/ln -s /etc/openldap/cacerts/${ldap_certname} `openssl x509 -hash -noout -in ${ldap_certname}`.0;touch /etc/openldap/cacerts/${ldap_certname}.hash_created",
      cwd => '/etc/openldap/cacerts',
      creates => "/etc/openldap/cacerts/${ldap_certname}.hash_created",
      require => File["/etc/openldap/cacerts/${ldap_certname}"],
      notify => Service['sssd'],
    }
    if $ldap_homedir == 'oddjob' {
      service { 'oddjobd':
        ensure  => 'running',
        enable  => true,
      }
    }
  } else {
    $ldapuri = 'ldap://'
    if $ldap_homedir == 'oddjob' {
      
      package { 'oddjob-mkhomedir':
        ensure  => present,
      }
      service { 'oddjobd':
        ensure  => 'running',
        enable  => true,
      }
    }
  }

  service { 'sssd':
      ensure  => 'running',
      enable  => true,
      restart  => "/etc/init.d/sssd stop;rm -f /var/lib/sss/db/cache_default.ldb ;/etc/init.d/sssd start",
  }

  service { 'nslcd':
      ensure => 'stopped',
      enable => false,
      before => Service['sssd'],
  }

  service { 'nscd':
      ensure  => 'running',
      enable  => true,
  }


  package { 'nss-pam-ldapd':
    ensure => present,
    before => Service['nslcd'],
  }

  package { 'nscd':
    ensure => present,
    before => Service['nslcd'],
  }

  package { 'sssd':
    ensure => "$sssd_ensure",
    before => Service['sssd'],
  }

}

