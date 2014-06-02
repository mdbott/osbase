# == Classification: Unclassified (provisional)
#
# == Class: ipa3
#
# Sets up SSH servers in /etc/ssh/sshd.conf depending on environment
#
# === Parameters
#
# [*sshrootlogin*]
#   When set to "no", this parameter disallows root from directly logging in
# [*sshx11forward*]
#   When set to "no", this parameter disables sshd's support for tunnelling X sessions over the
#   SSH tunnel
# [*sshtcpforward*]
#   When set to "no", this parameter disables sshd's support for tunnelling TCP connections
#   over the SSH tunnel
# === Hiera
#
#
# === Examples
#
# include ipa3
#
# === Maintainers
#
# UPS
#
class ipa3(
$basedn,
$realm,
$domain,
$server
) inherits ipa3::params {

  anchor {'ipa3::start':} ->class{'ipa3::package':} -> 
  class{'ipa3::config':basedn => $basedn,
    realm => $realm,
    domain => $domain,
    server => $server
  }
    ~> class{'ipa3::service':} -> anchor{'ipa3::end':}
}
