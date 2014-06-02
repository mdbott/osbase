# == Classification: Unclassified (provisional)
#
class nscd::service(
  $ensure = 'running' 
){
  include nscd::params
  service { 'nscd':
    ensure     => $ensure,
    name       => $nscd::params::servicename,
    enable     => $ensure ? {
          running => true,
          stopped => false,
          default => false
        },
    hasstatus  => true,
    hasrestart => true,
  }
 
}