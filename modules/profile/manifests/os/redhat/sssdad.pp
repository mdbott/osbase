# == Classification: Unclassified (provisional)
#
class profile::os::redhat::sssdad(
  $domain,
  $realm,
  $username,
  $password
) {

  class {'winbind3::package':} ->
  class {'kerberos': krbuser => $username, krbpassword => $password} ~>
  class {'winbind3::config':
    addomain      => $domain,
    kerberosrealm => $realm
  } ~>
  class {'winbind3::netjoin':
    server  => 'dc2008.test.dsd',
    username => $username,
    password => $password
  } ~>
  class {'sssd3': domains => [ "${realm}" ]} ->
  class{'nscd::service':  ensure => 'stopped'} ->
  class{'winbind3::service':  ensure => 'stopped'}
  
  
  
  class {'sssd3::domainclass':
    sssd_domain                     => $realm,
    id_provider                     => 'ad',
    ldap_id_mapping                 => 'false'
  } 
  
}
