# == Classification: Unclassified (provisional)
#
class nfs::redhat60server(
  $enabled = true
) {
  if $enabled==true {
    $ensure = 'running'
  } else {
    $ensure = 'stopped'
  }

  
  
  service { 'nfs':
    ensure     => $ensure,
    name       => $nfs::params::nfs_service,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['nfs::redhat60client'],
  }

}