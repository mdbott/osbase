# == Classification: Unclassified (provisional)
#
class winbind3::netjoin(
  $server,
  $username,
  $password
) {
  include winbind3::params
  exec { 'netjoin':
    command => "${winbind3::params::netjoincmd} ads join -k -U ${username}%${password}",
    creates => $winbind3::params::secretsfile,
  }
}