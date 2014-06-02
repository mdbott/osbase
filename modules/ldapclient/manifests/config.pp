# == Classification: Unclassified (provisional)
#
class ldapclient::config {

  file { '/var/ldap/ldap_client_file':
    ensure      => 'file',
    owner       => 'root',
    mode        => '0400',
    content     => template('ldapclient/ldap_client_file.erb'),
  }
  #fail("${ldapclient::encrypted} is the value of encrypted")
  file {'/var/ldap/ldap_client_cred':
    ensure      => 'file',
    owner       => 'root',
    mode        => '0400',
    content     => template('ldapclient/ldap_client_cred.erb'),
  }
  if $ldapclient::encrypted { 
    # Setup the encrypted keystore
    class{'ldapclient::keystore':}
    
    # Setup the dependencies
    File['/var/ldap/ldap_client_file']
    ~> File['/var/ldap/ldap_client_cred']
    ~> Class['ldapclient::keystore']
  } else {
    File['/var/ldap/ldap_client_file']
    ~> File['/var/ldap/ldap_client_cred']
  }




}
  
