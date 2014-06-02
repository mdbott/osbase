# == Classification: Unclassified (provisional)
#
class samba3::service{
  service { 'samba':
    ensure     => running,
    name       => $samba3::params::servicename,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}