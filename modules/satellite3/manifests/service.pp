# == Classification: Unclassified (provisional)
#
class satellite3::service{
  service { 'rhnsd':
    ensure => 'running',
    enable => true,
  }
}
