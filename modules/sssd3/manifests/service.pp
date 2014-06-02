# == Classification: Unclassified (provisional)
#
class sssd3::service(
  $ensure = 'running' 
) {
  service { 'sssd':
      ensure  => $ensure,
      enable     => $ensure ? {
          running => true,
          stopped => false,
          default => false
      },
  
  }
}