# == Classification: Unclassified (provisional)
#
class nslcd::service(
  $ensure = 'running' 
){
  service { 'nslcd':
      ensure  => $ensure,
      enable     => $ensure ? {
          running => true,
          stopped => false,
          default => false
        },
  }
}