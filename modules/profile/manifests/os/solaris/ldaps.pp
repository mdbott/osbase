# == Classification: Unclassified (provisional)
#
class profile::os::solaris::ldaps {
  
  class {'kerberos':} 
  -> class {'ldapclient': servers=>$profile::os::ldap::servers, 
                          basedn=>$profile::os::ldap::basedn,
                          bindpassword=>$profile::os::ldap::bindpassword,
                          certname =>$profile::os::ldap::certname,
                          encrypted =>$profile::os::ldap::encrypted
                          }
  ~> class {'nscd': }
}