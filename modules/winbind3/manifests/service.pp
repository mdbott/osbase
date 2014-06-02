# == Classification: Unclassified (provisional)
#
class winbind3::service(
  $ensure = 'running' 
){
  service { 'winbind':
    ensure     => $ensure,
    name       => $winbind3::params::servicename,
    enable     => $ensure ? {
          running => true,
          stopped => false,
          default => false
        },
    hasstatus  => true,
    hasrestart => true,
  }
}