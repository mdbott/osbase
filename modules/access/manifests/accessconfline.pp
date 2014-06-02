# == Classification: Unclassified (provisional)

define access::accessconfline (
  $ensure,
  $group,
  $hosts
) {
  if $group {
    $type = 'group'
  } else {
    $type = 'user'
  }
  include access::accessconf
  file { "${access::accessconf::basedir}/access.conf.d/${type}-${name}":
    ensure  => $ensure,
    content => template("access/etc/security/access.conf.line.erb"),
    notify  => Exec['rebuild-accessconf'],
  }
}
