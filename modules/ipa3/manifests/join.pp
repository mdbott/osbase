# == Classification: Unclassified (provisional)
#
class ipa3::join(
  $server,
  $basedn,
  $username,
  $password,
  $hostname = $::fqdn
) {
  include ipa3::params
  exec { 'ipajoin':
    command => "${ipa3::params::joincmd} -s ${server} -b ${basedn}-d -h ${hostname}",
    creates => $winbind3::params::secretsfile,
  }
}