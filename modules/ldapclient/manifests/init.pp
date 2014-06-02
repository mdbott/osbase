# == Classification: Unclassified (provisional)
#
# == Class: ldapclient
# Manage LDAP authentication on Solaris systems.
#
# === Parameters
#
#
# === Requires
#
# === Example
# class { 'ldapclient':
#   domains => [ 'uni.adr.unbc.ca' ],
# }
#
# === Authors
# Andrew Cox <ajcox@dsd.defence.gov.au>
#
# === Copyright
# 
#
class ldapclient (
  $servers,
  $basedn,
  $bindpassword,
  $certname,
  $encrypted
) {

 anchor {'ldapclient::start':}
 ->class{'ldapclient::params':}
 ->class{'ldapclient::package':}
 -> class{'ldapclient::config':}
 ~> class{'ldapclient::service':}
 -> anchor{'ldapclient::end':}


}
