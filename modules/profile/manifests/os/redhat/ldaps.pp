# == Classification: Unclassified (provisional)
#
class profile::os::redhat::ldaps(
  $servers,
  $basedn
) {
      # Set the encrypted ldap prefix
    
    $ldapuri = 'ldaps://'
    $encrypted = 'true'
    case $profile::os::ldap::servertype {
      'Solaris':  { 
                    $group_container     = 'group'
                    $netgroup_container  = 'netgroup'
                  }
      'Redhat':  { 
                    $group_container     = 'groups'
                    $netgroup_container  = 'netgroups'
                  }
    }
    # Setup the ssl cert
    file { '/etc/openldap/cacerts':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '755',
    }

    file { "/etc/openldap/cacerts/${profile::os::ldap::certname}":
      ensure  => 'file',
      source => "puppet:///modules/ldap/${profile::os::ldap::certname}",
      owner  => 'root',
      group   => 'root',
      mode    => '644',
      require => File['/etc/openldap/cacerts'] 
    }
    exec {'create key hash':
      command => "/bin/ln -s /etc/openldap/cacerts/${profile::os::ldap::certname} `openssl x509 -hash -noout -in ${profile::os::ldap::certname}`.0;touch /etc/openldap/cacerts/${profile::os::ldap::certname}.hash_created",
      cwd => '/etc/openldap/cacerts',
      creates => "/etc/openldap/cacerts/${profile::os::ldap::certname}.hash_created",
      require => File["/etc/openldap/cacerts/${profile::os::ldap::certname}"]
    }
    file {'/etc/openldap/ldap.conf':
        ensure  => present,
        content => template('profile/os/ldap.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644'
    }
    
       
    class{ 'sssd3::domainclass':
      id_provider                     => 'ldap',
      auth_provider                   => 'ldap',
      chpass_provider                 => 'ldap',
      sudo_provider                   => 'ldap',
      ldap_uri                        => inline_template("<%= @servers.map{|server| @ldapuri + server}.flatten.join(',') %>"),
      ldap_search_base                => $profile::os::ldap::basedn,
      ldap_id_use_start_tls           => 'true',
      ldap_tls_reqcert                => $lsbmajdistrelease ? {
                                          "5"  => "never",
                                          default => undef
                                         },
      ldap_tls_cacertdir              => '/etc/openldap/cacerts',
      ldap_schema                     => 'rfc2307',
      ldap_chpass_update_last_change  => true
      
    }
    class {'kerberos':} 
    -> class {'nslcd::service': ensure => 'stopped'}
    -> class {'sssd3': domains => [ 'default' ]}
    ~> class {'nscd': enabledcaches => ['hosts']}
  
}
