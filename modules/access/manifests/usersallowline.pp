# == Classification: Unclassified (provisional)

define access::usersallowline (
  $ensure,
  $group
) {
  if $group {
    $type = 'group'
  } else {
    $type = 'user'
  }
  include access::usersallow
  file { "${access::usersallow::basedir}/users.allow.d/${type}-${name}":
    ensure  => $ensure,
    content => template("access/etc/users.allow.line.erb"),
    notify  => Exec['rebuild-usersallow'],
  }
}