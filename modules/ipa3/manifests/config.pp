# == Classification: Unclassified (provisional)
#
class ipa3::config(
  $basedn,
  $realm,
  $domain,
  $server
) {
  file { '/etc/ipa/default.conf':
    ensure  => file,
    content => template($ipa3::params::configtemplate),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}