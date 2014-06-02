# == Classification: Unclassified (provisional)
#
class ipa3::service{
  service { 'ipa':
    ensure     => running,
    name       => $ipa3::params::servicename,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}