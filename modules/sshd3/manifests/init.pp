# == Classification: Unclassified (provisional)
#
# == Class: sshd3
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
# include sshd3
#
# === Maintainers
#
# UPS
#
class sshd3(
  $sshrootlogin='no',
  $sshtcpforward='no',
  $sshx11forward='no'
) inherits sshd3::params {

  anchor {'sshd3::start':} ->class{'sshd3::package':} -> class{'sshd3::config':}
    ~> class{'sshd3::service':} -> anchor{'sshd3::end':}
}
