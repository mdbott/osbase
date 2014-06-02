# == Classification: Unclassified (provisional)
#
# == Resource: sudo3::user
#
# Allows custom user entries via sudo3::user
#
# === Parameters
#
# [*ensure*]
#  File attribute to specify if the custom entry should be 'absent' or 'present'. No default
#
# [*password*]
#  Boolean value 'true' or 'false' to specify if the NOPASSWD tag is not set. Default is 'true' - the tag is not set and authentication is required.
#
# [*commands*]
#  Specify ALL or one or more commands that can be run in an array. Default is ['ALL'].
#
# [*groups*]
#  Specify the groups (user) the command can be run as in comma delimited string. Default is 'ALL'
#
# [*hosts*]
#  Specify the hosts the command can be run on in comma delimited string. Default is 'ALL'
#
#
# === Examples
#
# sudo3::user { 'bobsmith':  ensure   => present, password => true, commands => ['/usr/sbin/pwck, /usr/sbin/grpck'],}
#
# === Hiera
#
# Not applicable
#
#
# === Variables
#
# Not applicable
#
# === Templates
#
# Not applicable
#
# === Maintainers
#
# UPS
#
define sudo3::user (
  $ensure,
  $password = true,
  $commands = ['ALL'],
  $groups   = 'ALL',
  $hosts    = 'ALL'
) {
  sudo3::line { $name:
    ensure   => $ensure,
    password => $password,
    commands => $commands,
    groups   => $groups,
    hosts    => $hosts,
    linetype     => "user",
  }
}
