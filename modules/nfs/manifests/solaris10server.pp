# == Classification: Unclassified (provisional)
#
class nfs::solaris10server(
  $enabled = true
) {
  
  if $enabled==true {
    $ensure = 'running'
  } else {
    $ensure = 'stopped'
  }
    service { 'nfs/server':
      ensure     => $ensure,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
    }

}