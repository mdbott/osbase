# == Classification: Unclassified (provisional)
#
# == Resource: sudo3::line
#
# Allows custom user entries via sudo3::user
# Allows custom group entries via sudo3::group
# Allows custom netgroup entries via sudo3::netgroup
#
# === Parameters
#
# for resources sudo3::users, sudo3::group, sudo3::netgroup
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
# sudo3::group { 'sysadm': ensure   => present, commands => ['/usr/sbin/pwck'],}
# sudo3::netgroup { 'role-web-support': ensure   => present, groups => 'webadm', commands => ['ALL'],}
#
# === Hiera
#
# Not applicable
#
# === Variables
#
# [*fragment_dir*]
# Specifies the location/path for the diectory holding the custom user/group/netgroup entires
#
# === Templates
#
# line.erb
# Defines custom user/group/netgroup entires
#
# === Maintainers
#
# UPS
#
define sudo3::line (
  $ensure,
  $password = true,
  $commands = ['ALL'],
  $groups   = 'ALL',
  $hosts    = 'ALL',
  $linetype
) {
  # Workaround for names containing dots being ignored by sudo

  $fixedname = inline_template("<%= @name.gsub('.','_') %>")

  file { "${sudo3::params::fragment_dir}/${linetype}-${fixedname}":
    ensure  => $ensure,
    content => template("sudo3/line.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    require => Class['sudo3'],
  }
}
