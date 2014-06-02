# == Classification: Unclassified (provisional)
#
class ldapclient::service(
  $ensure = 'running' 
) {
  service { 'network/ldap/client':
      ensure  => $ensure,
      enable     => $ensure ? {
          running => true,
          stopped => false,
          default => false
      },
  
  }
}
