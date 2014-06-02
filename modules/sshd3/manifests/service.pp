# == Classification: Unclassified (provisional)
#
class sshd3::service{
  service { 'sshd':
    ensure     => running,
    name       => $sshd3::params::servicename,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}