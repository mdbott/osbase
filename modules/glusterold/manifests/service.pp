# == Classification: Unclassified (provisional)
#
class glusterold::service {
  service { 'glusterfsd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    restart   => '/etc/init.d/glusterfsd reload',
    require   => Class['glusterold::config'],
  }
}