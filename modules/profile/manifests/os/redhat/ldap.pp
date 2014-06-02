# == Classification: Unclassified (provisional)
#
class profile::os::redhat::ldap {
    # Set the unencrypted ldap prefix
    $ldapuri = 'ldap://'
    $encrypted = 'false'
    file {'/etc/openldap/ldap.conf':
      ensure  => present,
      content => template('profile/os/ldap.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644'
    }

    class {'kerberos': }
    -> class{'sssd3::service': ensure => 'stopped'}
    -> class{'nslcd':servers => $profile::os::ldap::servers, basedn=> $profile::os::ldap::basedn, ldapuri=> $ldapuri} 
    ~> class{'nscd':}
  
}